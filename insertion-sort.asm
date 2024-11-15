.model small
.data
    arr db "555554444333221$"
    enter db 0ah, 0dh, "$"
    len dw 000fh
    i dw 01h

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
               
    mov cx, len
    
    _loop:
        mov si, i
        mov al, arr[si]
        
        _while:
            dec si
            cmp si, 00ffh
            ja  _no_shift
            
            mov bh, arr[si]
            cmp bh, al
            jbe _no_shift
            
            mov arr[si+1], bh
            
            jmp _while
            _no_shift:
        
        mov arr[si+1], al    
        PRINT
        inc i
        loop _loop
        
    mov ah, 4ch
    int 21h
    end    
