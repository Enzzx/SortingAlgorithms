.model small
.data
    arr db "987654321$"
    enter db 0ah, 0dh, "$"
    len dw 09h
    i dw ?

.code
PRINT MACRO
    MOV AH, 09H
    LEA DX, ARR
    INT 21H
    LEA DX, ENTER
    INT 21H
ENDM

    mov dx, @data
    mov ds, dx

    mov i, 1h
    dec len
    mov cx, len

    _loop:
        mov si, i
        mov al, arr[si]

        _while:
            dec si
            cmp si, 00ffh
            ja  _no_shift
            mov bh, arr[si]
            mov bl, arr[si+1]

            cmp bh, al
            jna  _no_shift
            mov arr[si+1], bh

            mov dl, 01h
            cmp dl, 0h
            ja  _while
            _no_shift:

        mov arr[si+1], al
        inc i
        PRINT
        loop _loop
    _end:
    mov ah, 4ch
    int 21h
    end
