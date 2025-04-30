%include "macros.inc"

[ section .text ]
    global bubbleSort

    ; ----- bubbleSort -----
    ; Args:
    ;   (int*) rdi: array pointer
    ;   (int) rsi: array length
    ; Returns:
    ;   void
    ; Registers:
    ;   (int) rcx: outer loop counter
    ;   (int) rdx: inner loop counter
    ;   (bool) r8: swapped flag
    ;
    ;   (int) r9: temporary variable for swapping values
    ;   (int) r10: temporary variable
    ;   (int) r11: temporary variable
    func bubbleSort
        xor rcx, rcx    ; outer loop counter = 0
        xor r8, r8      ; swapped flag

        jmp .outerLoop
    .outerLoop:
        mov r10, rsi    ; calculate max outer iterations (n-1)
        dec r10         ; r10 = array length -1
        cmp rcx, r10    ; compare outer counter with n-1
        jge .done       ; exit if outer counter >= n-1

        mov r8b, false  ; swapped = false
        xor rdx, rdx    ; inner loop counter = 0

        mov r10, rsi    ; calculate inner loop bound (n-1 - outer counter)
        dec r10
        sub r10, rcx    ; r10 = (n-1) - rcx

    .innerLoop:
        mov r11d, [rdi + rdx*sizeofInt]      ; r11d = arrayPtr + rdx*sizeofInt
        mov r9d, [rdi + (rdx+1)*sizeofInt]   ; r9d  = arrayPtr + (rdx+1)*sizeofInt
        cmp r11d, r9d                        ; cmp array[rdx], array[rdx+1]
        jle .noSwap

        mov r8, true    ; set swapped flag to true

        ; swap values using pre-loaded registers
        mov [rdi + rdx*sizeofInt], r9d       ; array[rdx] = r9d
        mov [rdi + (rdx+1)*sizeofInt], r11d  ; array[rdx+1] = r11d

        jmp .incInner

    .noSwap:
        jmp .incInner

    .incInner:
        inc rdx         ; increment inner loop counter
        cmp rdx, r10    ; compare inner counter with (n-1 - outer counter)
        jl .innerLoop   ; continue inner loop if j < (n-1 - i)

    ; check if any swaps occurred in inner loop
    .continueOuter:
        cmp r8b, false  ; if no swaps, exit early
        je .done
        inc rcx         ; increment outer counter
        jmp .outerLoop

    .done:
        ret
    end

%if 0

void bubbleSort(
    int* rdi, // array pointer
    int rsi // array length
) {
    bool r8; // swapped?
    int r9; // temporary variable for swapping values

    for (int rcx = 0; rcx < rsi-1; rcx++) {
        for (int rdx = 0; rdx < rsi-1; rdx++) {
            /*
            cmp [rdi+(rdx*sizeofInt)], [rdi+(rdx+1)*sizeofInt]
            */
            if (rdi[rdx] > rdi[rdx+1]) {
                /*
                mov r9d, [rdi+(rdx*sizeofInt)]
                mov [rdi+(rdx*sizeofInt)], [rdi+(rdx+1)*sizeofInt]
                mov [rdi+(rdx+1)*sizeofInt], r9d
                */
                r9 = rdi[rdx];
                rdi[rdx] = rdi[rdx+1];
                rdi[rdx+1] = r9;

                /// mov r8, true
                r8 = true;
            }
        }

        /*
        cmp r8, false
        je .done
        */
        if (!r8) break;
    }
}

%endif
