.model small
.stack 100h
.data
    arr db "987654321$"
    len db 09h
    enter db 0ah, 0dh, "$"
    i db ?
    curr_size db ?
    leftArr db 9 dup(0)
    rightArr db 9 dup(0)
    mergeIndex dw ? 

.code
PRINT MACRO
    LEA DX, ARR
    MOV AH, 09H
    INT 21H
    LEA DX, ENTER
    INT 21H
ENDM

ARR_ADD MACRO DEST, SRC, D_IDX, S_IDX
    PUSH DX
    
    MOV AX, S_IDX
    LEA SI, SRC
    ADD SI, AX
    MOV AL, [SI]
    
    MOV DX, D_IDX
    LEA DI, DEST
    ADD DI, DX
    MOV [DI], AL
    
    POP DX
ENDM

start:
    mov dx, @data
    mov ds, dx
    
    call _mergeSort
    
    mov ah, 4ch
    int 21h
    
    _mergeSort:
        mov curr_size, 04h
        _outerloop:
            mov i, 00h
            mov ax, 0000h
            mov bx, 0000h
            mov cx, 0000h
            mov dx, 0000h
            
            _innerloop:
                ;BH = left / BL = mid / CH = right
                mov bh, i
                mov bl, i
                add bl, curr_size
                dec bl
                mov ch, bl
                add ch, curr_size
                
                ;aumenta i
                mov dl, curr_size
                shl dl, 1
                add i, dl
                
                call _merge
                ;verifica se left é menor que o tamanho da array
                mov dl, len
                cmp i, dl
                jb  _innerloop
                 
            shl curr_size, 1
            PRINT
            ;verifica se os elementos a mergearem é menor que o total da array
            cmp curr_size, dl
            jb _outerloop
        ret
            
                
    _merge:
        ;n1 = dh / n2 = dl
        mov dh, bl
        sub dh, bh
        inc dh
        
        mov dl, ch
        sub dl, bl
                   
        ;nesse momento do código:
        ;bh = left/ bl = mid / dh = n1 / dl = n2 / cx = loop
        push bx
        mov bl, bh
        mov bh, 00h
        mov mergeIndex, bx  ;mergeIndex começa com left
        pop bx
                           
        mov cx, 00h
        mov cl, dh
        mov si, 0000h
        
        ;push bx
        ;mov bl, bh
        ;mov bh, 00h
        _temp_left:
            ;add bx, si
            ARR_ADD leftArr, arr, si, mergeIndex
            ;sub bx, si
            inc mergeIndex
            inc si
            loop _temp_left
        ;pop bx
        
        
        mov cx, 0000h
        mov cl, dl
        mov si, 0000h
        
        ;push bx
        ;mov bh, 00h
        _temp_right:
            ;add bx, si
            ARR_ADD rightArr, arr, si, mergeIndex
            ;sub bx, si
            inc mergeIndex
            inc si
            loop _temp_right
        ;pop bx
        
        ;SI = left index / DI = right index / mergeIndex = itself
        ;no momento ax será usando pra CMPs e cx está livre
        mov si, 0000h
        mov di, 0000h
        mov bl, bh
        mov bh, 00h
        mov mergeIndex, bx
        mov cx, 0000h
        
        _add_loop:
            ;compara left index com n1 e depois right index com n2
            mov ax, 0000h
            mov al, dh
            cmp si, ax
            ja  _copy_right
            mov al, dl
            cmp di, ax
            ja  _copy_left
            
            mov ah, leftArr[si]
            mov al, rightArr[di]
            cmp ah, al
            jbe _add_left
            ja  _add_right
            
            ;verifica se ainda há elementos pra adicionar na array merge
            _verify_loop:
            mov al, dh
            add al, dl
            sub ax, mergeIndex
            cmp ax, 0000h
            jbe _return
            jmp  _add_loop
          
          
        _add_left:
        ARR_ADD arr, leftArr, mergeIndex, si
        inc si
        inc mergeIndex
        cmp ah, al
        jmp _verify_loop                                  
        
        _add_right:
        ARR_ADD arr, rightArr, mergeIndex, di
        inc di
        inc mergeIndex
        cmp ah, al
        jmp _verify_loop
        
        
        _copy_left:
        mov cl, dh
        sub cx, si
        
        _copy_left_num:
            ARR_ADD arr, leftArr, mergeIndex, si
            inc mergeIndex
            inc si
            loop _copy_left_num
        jmp _return
        
        
        _copy_right:
        mov cl, dl
        sub cx, di
        
        _copy_right_num:
            ARR_ADD arr, rightArr, mergeIndex, di
            inc mergeIndex
            inc di
            loop _copy_right_num
        jmp _return
        
        
        _return:
            ret
            
end start                    
