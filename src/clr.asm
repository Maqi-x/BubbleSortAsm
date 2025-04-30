[ section .rodata ]
    global RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE, ORANGE
    global RESET, BOLD, ITALIC, UNDERLINE
    global BOLD_RED, BOLD_GREEN, BOLD_YELLOW, BOLD_BLUE, BOLD_MAGENTA, BOLD_CYAN, BOLD_WHITE, BOLD_ORANGE


    RED     db 0x1B, '[', '9', '1', 'm', 0
    GREEN   db 0x1B, '[', '9', '2', 'm', 0
    YELLOW  db 0x1B, '[', '9', '3', 'm', 0
    BLUE    db 0x1B, '[', '9', '4', 'm', 0
    MAGENTA db 0x1B, '[', '9', '5', 'm', 0
    CYAN    db 0x1B, '[', '9', '6', 'm', 0
    WHITE   db 0x1B, '[', '9', '7', 'm', 0
    ORANGE  db 0x1B, '[', '9', '3', 'm', 0

    RESET   db 0x1B, '[', '0', 'm', 0

    BOLD    db 0x1B, '[', '1', 'm', 0
    ITALIC  db 0x1B, '[', '3', 'm', 0
    UNDERLINE db 0x1B, '[', '4', 'm', 0

    BOLD_RED     db 0x1B, '[', '1', ';', '9', '1', 'm', 0
    BOLD_GREEN   db 0x1B, '[', '1', ';', '9', '2', 'm', 0
    BOLD_YELLOW  db 0x1B, '[', '1', ';', '9', '3', 'm', 0
    BOLD_BLUE    db 0x1B, '[', '1', ';', '9', '4', 'm', 0
    BOLD_MAGENTA db 0x1B, '[', '1', ';', '9', '5', 'm', 0
    BOLD_CYAN    db 0x1B, '[', '1', ';', '9', '6', 'm', 0
    BOLD_WHITE   db 0x1B, '[', '1', ';', '9', '7', 'm', 0
    BOLD_ORANGE  db 0x1B, '[', '1', ';', '9', '3', 'm', 0
