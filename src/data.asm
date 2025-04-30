%include "macros.inc"

[ section .data ]
    global beforeFmt, afterFmt, numfmt, commaSpace, strfmt, newline, openSquareBracked, closeSquareBracked

    beforeFmt db "%s%s Before sorting:%s ", 0
    beforeFmt_len equ ($ - beforeFmt)

    afterFmt db "%s After sorting:%s ", 0
    afterFmt_len equ ($ - afterFmt)

    numfmt db "%d", 0
    commaSpace db ", ", 0
    strfmt db "%s", 0
    newline db 10, 0

    openSquareBracked db "[", 0
    closeSquareBracked db "]", 0
