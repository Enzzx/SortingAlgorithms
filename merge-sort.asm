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
    PUSH DX
    
    MOV CX, S_IDX
    LEA SI, SRC
    ADD SI, CX
    MOV CL, [SI]
    
    MOV DX, D_IDX
    LEA DI, DEST
    ADD DI, DX
    MOV [DI], CL
    
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
        
        mov cx, 00h ;zera cx pra loopar _temp_left e _temp_right
        
        mov cl, dh
        mov si, 00h
        push bx
        mov bl, bh
        mov bh, 00h
        _temp_left: 
            add bx, si
            ARR_ADD left, arr, si, bx
            sub bx, si
            inc si
            loop _temp_left
        pop bx
        
        mov cl, dl
        mov si, 00h
        push bx
        mov bh, 00h
        inc bx
        _temp_right:
            add bx, si
            ARR_ADD right, arr, si, bx
            sub bx, si
            inc si
            loop _temp_right
        pop bx    
            
        ;SI = left index  /  DI = right index  /  BX = arr index
        ;AH e AL = comp / CX = n1 / DH = n1 / DL = n2   
        mov si, 00h  
        mov di, 00h
        
        mov bl, ;AAAHHHH NÃO TEM REGISTRAFOR SOBRANDOOASCOIAÇVDSAIHVD 
        mov bl, bh
        mov bh, 00h
        
        mov cx, 0000h
        mov cl, dh   
        
        _add_loop:   
            cmp si, cx
            jae _copy_right
            cmp di, dx
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
        ARR_ADD arr, left, bx, si
        inc si
        inc bx
        ret
        
        _add_right:
        ARR_ADD arr, right, bx, di
        inc di
        inc bx
        ret
        
        
        _copy_left:
        sub cx, si
        
        _copy_left_num:
            ARR_ADD arr, left, bl, si
            inc bl
            inc si
            loop _copy_left_num    
        cmp si, dh
        jae _return
        
        _copy_right:
        sub cx, di
        _copy_right_num:
            ARR_ADD arr, left, bl, di
            inc bl
            inc di
            loop _copy_right_num    
        cmp di, dl
        jae _return    
        
            
        _return:
        ret   
                
        
end start           
