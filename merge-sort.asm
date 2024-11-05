.model small
.stack 100h
.data
    arr db "987654321$"
    len db 09h 
    enter db 0ah, 0dh, "$"
    left db ?
    right db ?
    i db ?
    curr_size db ?
    
.code
PRINT MACRO
    MOV AH, 09H
    LEA DX, ARR
    INT 21H
    LEA DX, ENTER
    INT 21H
ENDM  

ARR_ADD MACRO DEST, SRC, D_IDX, S_IDX
    PUSH CX
    push DX
    
    MOV DX, D_IDX
    MOV CX, SRC[S_IDX]
    MOV DEST[DL], CL
    
    POP CX
    POP DX
ENDM

start:    
    mov ax, @data
    mov ds, ax
    
    call _mergeSort
    
    mov ah, 4ch
    int 21h    
    
    
    _mergeSort:
        mov curr_size, 01h
        _outerloop:
            mov i, 00h

            _innerloop:
                ;BH = left  /  BL = mid;  /  CH = right
                mov bh, i             
                mov bl, i             
                add bl, curr_size-1
                mov ch, bl            
                add ch, curr_size
                
                mov dl, curr_size     
                shl dl, 1
                add i, dl
                
                call _merge
                mov dl, len
                cmp i, dl
                jb  _innerloop
                                    
            shl curr_size, 1
            PRINT
            cmp curr_size, dl
            jb  _outerloop
            ret
            
                     
    _merge:
        mov dh, bl  ;n1
        sub dh, bh
        dec dh
        
        mov dl, ch  ;n2
        sub dl, bl
        
        mov cl, dh
        mov si, 00h
        push bx
        _temp_left:
            add bx, si
            ARR_ADD left, arr, si, bh
            sub bx, si
            inc si
            loop _temp_left
        pop bx
        
        mov cx, dl
        mov si, 00h
        push bx
        _temp_right:
            add bx, si
            inc bx
            ARR_ADD right, arr, si, bl
            sub bx, si
            dec bx
            inc si
            loop _temp_right
        pop bx    
            
        ;SI = left index  /  DI = right index  /  BL = arr index    
        mov si, 00h  
        mov di, 00h 
        mov bl, bl   
        
        _add_loop:   
            cmp si, dh
            jae _copy_right
            cmp di, dl
            jae _copy_left
            
            mov ah, left[si]
            mov al, right[di]
            cmp ah, al
            jbe _add_left
            ja  _add_right
                                                 
            mov al, dh
            add al, dl
            sub al, bl
            cmp al, 00h
            jbe _return
            jp  _add_loop    
         
        
        _add_left:
        ARR_ADD arr, left, bl, si
        inc si
        inc bl
        ret
        
        _add_right:
        ARR_ADD arr, right, bl, di
        inc di
        inc bl
        ret
        
        
        _copy_left:
        mov cl, dh
        sub cl, si
        _copy_left_letter:
            ARR_ADD arr, left, bl, si
            inc bl
            inc si
            loop _copy_left_letter    
        cmp si, dh
        jae _return
        
        _copy_right:
        mov cl, dh
        sub cl, si
        _copy_right_letter:
            ARR_ADD arr, left, bl, di
            inc bl
            inc di
            loop _copy_right_letter    
        cmp di, dl
        jae _return    
        
            
        _retun:
        ret   
                
        
end start           
