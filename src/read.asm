%include "macros.inc"
%include "data.inc"

[ section .bss ]
    numBuf resb 21

[ section .text ]
    global parseArray
    extern printf

    ; ----- parseArray -----
    ; Args:
    ;   (int*) rdi: pointer to array of integers
    ;   (int) rsi: max number of elements
    ;   (char*) rdx: input string
    ; Returns:
    ;   (int) rax: number of elements parsed if successful, -1 otherwise
    ; Registers:
    ;   (int) r8: bytes count saved to numBuf
    ;   (int) r9: index of current element in array
    ;   (bool) r10: flag indicating if a negative number is being parsed
    ;   (int) r11: temporary value
    ;   (int) r12: temporary value
    ;   (char) r13: current character
    ;   (int) r14: loop counter
    ;   (bool) r15: flag indicating if .append must jump to .done instead of .loopStart
    func parseArray
        pushAll r8, r9, r10, r11, r12, r13, r14, r15
        zeroAll r8, r9, r10, r11, r12, r13, r14, r15

        mov r15, false

    .loopStart:
        ; check if array is full
        cmp r9, rsi
        jge .done

        ; load current character
        movzx r13, byte [rdx + r14]
        inc r14

        ; check for end of string or newline
        cmp r13, 0
        je .processRemaining
        cmp r13, 10
        je .processRemaining

        ; check for whitespace
        cmp r13, ' '
        je .loopStart
        cmp r13, 9
        je .loopStart

        ; Handle minus
        cmp r13, '-'
        je .onMinus

        ; Handle comma
        cmp r13, ','
        je .append

        ; Validate digit
        cmp r13, '0'
        jb .error
        cmp r13, '9'
        ja .error

        jmp .onNumber

    .onNumber:
        ; Check for buffer overflow (max 19 digits)
        cmp r8, 19
        jg .error
        mov [numBuf + r8], r13
        inc r8
        jmp .loopStart

    .append:
        ; Check if there are digits to process
        test r8, r8
        jz .error

        ; Convert numBuf to integer
        xor r11, r11
        mov r12, numBuf
    .convertLoop:
        cmp r8, 0
        je .convertDone

        ; multiply and check overflow
        imul r11, r11, 10
        jo .error

        ; add digit and check overflow
        movzx rax, byte [r12]
        sub al, '0'
        add r11, rax
        jo .error

        inc r12
        dec r8
        jmp .convertLoop

    .convertDone:
        test r10, r10
        jz .store    ; if isNegative flag is not set, store the number
        neg r11      ; else negate the number
        jmp .store   ; and store the number

    .store:
        ; check array bounds
        cmp r9, rsi
        jge .error
        mov [rdi + r9*4], r11
        inc r9

        ; reset state
        xor r8, r8
        xor r10, r10

        cmp r15, true
        je .done
        jmp .loopStart

    .onMinus:
        ; ensure minus is at start and no digits
        test r8, r8    ; numBuf is empty?
        jnz .error
        test r10, r10  ; isNegative flag is already set?
        jnz .error

        mov r10, 1
        jmp .loopStart ; continue parse loop

    ; handle remaining digits after loop
    .processRemaining:
        test r8, r8
        jz .done

        mov r15, true
        jmp .append

    ; pop registers and return success
    .done:
        mov rax, r9
        popAll r15, r14, r13, r12, r11, r10, r9, r8
        ret

    ; pop registers and return failure
    .error:
        mov rax, -1
        popAll r15, r14, r13, r12, r11, r10, r9, r8
        ret
    end

%if 0

char numBuf[21];

// rdi - pointer to output array
// rsi - max number of values
// rdx - max input bytes
// rcx - pointer to input string
// r8  - bytes count saved to numBuf
// r9  - index into input string
// r10 - isNegative flag
// r11 - parsed value
// r12 - unused/temp
// r13 - current character
// r14 - parsed values count
bool parseArray(int* rdi, int rsi, int rdx, char* rcx) {
    push(r8, r9, r10, r11, r12, r13, r14);

    r8 = 0;
    r9 = 0;
    r10 = 0;
    r11 = 0;
    r12 = 0;
    r13 = 0;
    r14 = 0;

    while (r14 < rsi && r9 < rdx) {
        r13 = rcx[r9];

        if (isspace(r13)) {
            r9++;
            continue;
        }

        if (r13 == '-') {
            if (!r10 && r8 == 0) {
                r10 = 1;
                r9++;
                continue;
            } else {
                pop(r14, r13, r12, r11, r10, r9, r8);
                return false;
            }
        }

        if (isdigit(r13)) {
            if (r8 >= 19) {
                pop(r14, r13, r12, r11, r10, r9, r8);
                return false;
            }
            numBuf[r8++] = r13;
            r9++;
            continue;
        }

        if (r13 == ',' || r13 == '\n') {
            if (r8 == 0) {
                pop(r14, r13, r12, r11, r10, r9, r8);
                return false;
            }

            numBuf[r8] = 0;
            if (sscanf(numBuf, "%d", &r11) != 1) {
                pop(r14, r13, r12, r11, r10, r9, r8);
                return false;
            }

            if (r10)
                r11 = -r11;

            rdi[r14++] = r11;

            r8 = 0;
            r10 = 0;
            r9++;

            if (r13 == '\n') {
                pop(r14, r13, r12, r11, r10, r9, r8);
                return true;
            }

            continue;
        }

        pop(r14, r13, r12, r11, r10, r9, r8);
        return false;
    }

    if (r8 > 0) {
        numBuf[r8] = 0;
        if (sscanf(numBuf, "%d", &r11) != 1) {
            pop(r14, r13, r12, r11, r10, r9, r8);
            return false;
        }

        if (r10) r11 = -r11;

        rdi[r14++] = r11;
    }

    pop(r14, r13, r12, r11, r10, r9, r8);
    return true;
}

%endif
