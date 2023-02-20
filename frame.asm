.code

;=======================================================;

Draw_Rama   proc  

;=======================================================;

;Input coordinates
    mov ah, 09h
    mov dx, offset Enter_x
    int 21h

    mov ah, 0ah
    mov dx, offset x_coord
    int 21h

    mov ah, 09h
    mov dx, offset crlf
    int 21h

    mov ah, 09h
    mov dx, offset Enter_Y
    int 21h

    mov ah, 0ah
    mov dx, offset y_coord
    int 21h

    mov ah, 09h
    mov dx, offset crlf
    int 21h
        
    mov ah, 09h
    mov dx, offset Enter_Length
    int 21h

    mov ah, 0ah
    mov dx, offset length
    int 21h

    mov ah, 09h
    mov dx, offset crlf
    int 21h

    mov ah, 09h
    mov dx, offset Enter_Width
    int 21h

    mov ah, 0ah
    mov dx, offset width
    int 21h

    mov ah, 09h
    mov dx, offset crlf
    int 21h
;=======================================================;
;draw spaces
    mov bx, 0b800h
    mov es, bx
    xor bx, bx
    mov cx, 80 * 25

draw_space:
    mov byte ptr es:[bx], 20h
    mov byte ptr es:[bx + 1], 0ch
    add bx, 2
    loop draw_space

;=======================================================;

;Work with coordinates
;x coordinate
    xor di, di
    xor bx, bx
    xor cx, cx
    mov cl, cur_len_x
    xor ax, ax	
    mov si, cx	
    mov cl, 10
    
to_dec_x:   
    mov bl, byte ptr x[di]
	sub bl, '0'
	mul cx	
	add ax, bx 
	inc di	
	cmp di, si	
	jb to_dec_x

;save x
    push ax ;size = 1

;y coordinate
    xor di, di
    xor bx, bx
    xor cx, cx
    mov cl, cur_len_y
    xor ax, ax	
    mov si, cx	
    mov cl, 10
    
to_dec_y:   
    mov bl, byte ptr y[di]
	sub bl, '0'
	mul cx	
	add ax, bx 
	inc di	
	cmp di, si	
	jb to_dec_y

;x = cx y = ax
    pop cx ;size = 0

;=======================================================;
;Start of the video_mem

    mov bx, 0b800h
    mov es, bx

    mov bx, cx
    mov cl, 80
    mul cx
    add bx, ax

;save bx
    mov dx, bx
    add dx, 80 * 4 + 2 
    push dx ;size = 1(the adress of the writing number)
    push bx ;size = 2
;=======================================================;
;Length
    xor di, di
    xor bx, bx
    xor cx, cx
    mov cl, cur_len_len
    xor ax, ax	
    mov si, cx	
    mov cl, 10
    
to_dec_len:   
    mov bl, byte ptr len[di]
	sub bl, '0'
	mul cx	
	add ax, bx 
	inc di	
	cmp di, si	
	jb to_dec_len
    
;cx = length
    mov cx, ax

;returning of bx
    pop bx ;size = 1
;save length
    push cx ;size = 2
;save starting video_mem
    push bx ;size = 3

;=======================================================;

;draw up_line
    mov byte ptr es:[bx], 0c9h
    mov byte ptr es:[bx + 1],5bh
    add bx, 2

next_1:
    mov byte ptr es:[bx], 0cdh
    mov byte ptr es:[bx + 1],5bh
    add bx, 2
    loop next_1

    mov byte ptr es:[bx], 0bbh
    mov byte ptr es:[bx + 1],5bh

;=======================================================;
;Width
    xor di, di
    xor bx, bx
    xor cx, cx
    mov cl, cur_len_wid
    xor ax, ax	
    mov si, cx	
    mov cl, 10
    
to_dec_wid:   
    mov bl, byte ptr wid[di]
	sub bl, '0'
	mul cx	
	add ax, bx 
	inc di	
	cmp di, si	
	jb to_dec_wid
;=======================================================;

;returning starting video_mem
    pop bx ;size = 2
;returning the length
    pop cx ;size = 1
;save the length
    push cx ;size = 2

;=======================================================;
;draw vert lines
    mov di, ax ;di = width
    add bx, 80 * 2
    add cx, cx
    add cx, 2
draw_vert:
    mov byte ptr es:[bx], 0bah
    mov byte ptr es:[bx + 1],5bh
    add bx, cx
    mov byte ptr es:[bx], 0bah
    mov byte ptr es:[bx + 1],5bh
    sub bx, cx
    add bx, 80 * 2
    dec di
    cmp di, 0
    ja draw_vert

;=======================================================;
;draw down_line
;returning the length
    pop cx ;size = 1
    mov byte ptr es:[bx], 0c8h
    mov byte ptr es:[bx + 1],5bh
    add bx, 2

next_2:
    mov byte ptr es:[bx], 0cdh
    mov byte ptr es:[bx + 1],5bh
    add bx, 2
    loop next_2

    mov byte ptr es:[bx], 0bch
    mov byte ptr es:[bx + 1],5bh

;=======================================================;
    pop dx ;size = 0
    ret
    endp

;=======================================================;

Enter_X db "Enter the X coordinate: $"

Enter_Y db "Enter the Y coordinate: $"

Enter_Length db "Enter the length of the drame: $"

Enter_Width db "Enter the width of the drame: $"

x_coord:
    max_len_x db 4
    cur_len_x db ?
    x db 4 dup ('$')

y_coord:
    max_len_y db 4
    cur_len_y db ?
    y db 4 dup ('$')

length:
    max_len_len db 4
    cur_len_len db ?
    len db 4 dup ('$')

width:
    max_len_wid db 4
    cur_len_wid db ?
    wid db 4 dup ('$')

;=======================================================;