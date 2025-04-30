%ifndef MACROS_INC
%define MACROS_INC

%define sizeofInt 4
%define sizeofPointer 8
%define sizeofChar 1

%define true 1
%define false 0

%define stdin 0
%define stdout 1
%define stderr 2

%macro func 1
    %1:
        ; push rbp
        ; mov rbp, rsp
        ; sub rsp, 16
%endmacro

%macro end 0
    ; mov rsp, rbp
    ; pop rbp
    ret
%endmacro

%macro return 1
    ; mov rsp, rbp
    ; pop rbp
    mov rax, %1
    ret
%endmacro

%macro processArray 3
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3

    call _processArray
%endmacro

%macro pushAll 1-*
    %rep %0
        push %1
        %rotate 1
    %endrep
%endmacro

%macro popAll 1-*
    %rep %0
        pop %1
        %rotate 1
    %endrep
%endmacro

%macro zeroAll 1-*
    %rep %0
        xor %1, %1
        %rotate 1
    %endrep
%endmacro

%endif
