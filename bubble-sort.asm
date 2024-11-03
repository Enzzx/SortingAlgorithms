.model small
.data
    arr db "29185098654211023854$"
    enter db 0ah, 0dh, "$"
    len dw 14h

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

    dec len

    _outerloop:
        mov cx, len
        mov si, 0h

        _innerloop:
            mov al, arr[si]
            mov bl, arr[si+1]
            cmp al, bl
            jna  _no_swap

            mov arr[si], bl
            mov arr[si+1], al

            _no_swap:
            inc si
            loop _innerloop

        PRINT
        dec len
        cmp len, 0h
        ja  _outerloop
        jbe _end

    _end:
    mov ah, 4ch
    int 21h
    end
