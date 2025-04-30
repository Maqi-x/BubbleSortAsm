; Bubble sort in assembly x86_64:
%include "macros.inc"
%include "sort.inc"
%include "data.inc"
%include "clr.inc"
%include "read.inc"

%define maxUserArraySize 100

[ section .data ]
    testArray1 dd 5, 3, 8, 1, 2, 7, 4, 6, 9, 0
    testArray1_len equ ($ - testArray1) / sizeofInt
    testArray1_name db "testArray1", 0
    testArray2 dd 10, 200, 9, 8, 16, 100, 6, 5, 15, 4, 3, 2, 1
    testArray2_len equ ($ - testArray2) / sizeofInt
    testArray2_name db "testArray2", 0
    testArray3 dd 1, 2, 3, 4, 5, 200, 6, 7, 8, 9, 10
    testArray3_len equ ($ - testArray3) / sizeofInt
    testArray3_name db "testArray3", 0

    userArray_name db "userArray", 0

    outFmt db "%d", 10, 0     ; "%d\n"

    errorFmt db "%s[ ERROR ]:%s Invalid input format%s", 10, 0

[ section .bss ]
    inputBuffer resb 128
    result resd maxUserArraySize

[ section .text ]
    extern printf, exit, puts, strlen, scanf
    global _start, main

    _start:
        ; save argc and argv
        mov rdi, [rsp]          ; argc is the first value on the stack
        lea rsi, [rsp + 8]      ; argv is the address of the next value on the stack

        call main               ; result has been stored in rax

        ; exit with code returned by main
        mov rdi, rax
        call exit

    ; ----- main -----
    ; Args:
    ;   (int) rdi: argc
    ;   (char**) rsi: argv
    ; Returns:
    ;   (int) rax: return value of main
    ; Registers:
    ;   none
    func main
        push rdi   ; save argc
        push rsi   ; save argv

        processArray testArray1, testArray1_len, testArray1_name
        processArray testArray2, testArray2_len, testArray2_name
        processArray testArray3, testArray3_len, testArray3_name

        pop rsi
        pop rdi

        cmp rdi, 2
        jge .userArray

        return 0

    .userArray:
        mov r15, [rsi + 1*sizeofPointer]   ; first argument
        push rdi
        push rsi

        lea rdi, [result]
        mov rsi, maxUserArraySize
        mov rdx, r15
        call parseArray

        pop rsi
        pop rdi

        cmp rax, -1
        je .showError

        processArray result, rax, userArray_name

        jmp .done

    .showError:
        mov rdi, errorFmt
        mov rsi, BOLD_RED
        mov rdx, ORANGE
        mov rcx, RESET

        xor eax, eax
        call printf
        jmp .done

    .done:
        return 0
        ret
    end

    ; ----- print -----
    ; Args:
    ;   (char*) rdi: string pointer
    ; Returns:
    ;   (int) rax: return value of printf
    ; Registers:
    ;   none
    func print
        mov rsi, rdi
        mov rdi, strfmt
        call printf
    end

    ; ----- processArray ----
    ; Args:
    ;   (int*) rdi: array pointer
    ;   (int)  rsi: array length
    ;   (char*) rdx: array name
    ; Returns:
    ;   void
    ; Registers:
    ;   (char*) rdi: temporary pointer for array name
    func _processArray
        ; Save array ptr and length locally
        pushAll rdi, rsi, rdx, rbx

        ; print "arrayname Before sorting: "
        mov rdi, beforeFmt
        mov rsi, BOLD_CYAN
        mov rdx, rdx
        mov rcx, RESET
        xor eax, eax      ; clear rax before printf (variadic call ABI requirement)
        call printf

        ; restore array pointer and length for printArray
        popAll rbx, rdx, rsi, rdi

        ; call printArray array, length
        push rdi          ; save again for after sorting
        push rsi

        call printArray

        pop rsi
        pop rdi
        call bubbleSort

        ; print "After: "
        pushAll rdi, rsi, rdx

        mov rdi, afterFmt
        mov rsi, BOLD_GREEN
        mov rdx, RESET
        xor eax, eax      ; clear rax before printf (variadic call ABI requirement)
        call printf

        popAll rdx, rsi, rdi
        call printArray
    end

    ; ----- printArray -----
    ; Args:
    ;   (int*) rdi: array pointer
    ;   (int) rsi: array length
    ; Returns:
    ;   void
    ; Registers:
    ;   (int) rcx: loop counter
    ;   (int*) r8: array pointer
    ;   (int) r9: temporary variable
    func printArray
        mov rcx, rsi          ; loop counter = array length
        mov r8, rdi           ; save original array pointer

        push r8
        push rcx

        mov rdi, openSquareBracked
        call print

        pop rcx
        pop r8

    .loop:
        cmp rcx, 0
        je .end

        mov r9d, [r8]         ; load current element into r9d

        push rcx              ; save loop counter
        push r8               ; save array pointer

        ; print current element
        mov rdi, numfmt       ; "%d"
        mov esi, r9d
        xor eax, eax
        call printf

        pop r8
        pop rcx

        dec rcx               ; decrement loop counter
        jz .skipComma         ; if last element, skip comma

        push rcx              ; save loop counter
        push r8               ; save array pointer

        ; print comma and space
        mov rdi, commaSpace
        call print

        pop r8
        pop rcx

    .skipComma:
        add r8, sizeofInt     ; move to next element
        jmp .loop             ; if rcx != 0, loop again

    .end:
        mov rdi, closeSquareBracked
        call puts

        ret
    end
