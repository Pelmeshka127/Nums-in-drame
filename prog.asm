.model tiny
.code
org 100h

;=======================================================;
start:
;=======================================================;
;Input of the numbers
;=======================================================;
        mov ah, 09h
        mov dx, offset Enter_first
        int 21h

        mov ah, 0ah
        mov dx, offset first_num
        int 21h

        mov ah, 09h
        mov dx, offset crlf
        int 21h

        mov ah, 09h
        mov dx, offset Enter_Second
        int 21h

        mov ah, 0ah
        mov dx, offset second_num
        int 21h

        mov ah, 09h
        mov dx, offset crlf
        int 21h
;=======================================================;

	call Draw_Rama
	mov bx, dx ;bx is the adrees start writing
	push bx ;size = 1

;=======================================================;
;from ASCII to dec
;=======================================================;
    xor di, di
    xor bx, bx
    xor cx, cx
    mov cl, cur_len_2
    xor ax, ax	
    mov si, cx	
    mov cl, 10
    
to_dec_second:   
    mov bl, byte ptr num_2[di]
	sub bl, '0'
	mul cx	
	add ax, bx 
	inc di	
	cmp di, si	
	jb to_dec_second

    push ax ;saving 2_num; size = 2

    xor di, di
    xor bx, bx
    xor cx, cx
    mov cl, cur_len_1
    xor ax, ax	
    mov si, cx	
    mov cl, 10
    
to_dec_first:   
    mov bl, byte ptr num_1[di]
	sub bl, '0'
	mul cx	
	add ax, bx 
	inc di	
	cmp di, si	
	jb to_dec_first

    pop cx ;size = 1 (cx = num_2) (ax = num_1)

;=======================================================;
;Sum ax + bx
	push ax ;saving first num; size = 2

	call Summary

	pop dx ;dx = num_1; size = 1

	pop bx ;size = 0(adress of video mem)

	push dx ;saving num_1(size = 1)//
	push cx	;saving num_2(size = 2)//
	push bx ;saving adress of the video_mem (size = 3)

	push ax ;size = 4(saving value)

	call Print_Dec

	pop ax ;size = 3
	push ax ;size = 4

	call Dec_To_Bin

	pop ax ;size = 3

	call Dec_To_Hex

;=======================================================;
;Some workes...
	pop bx ;returning the adress of the video_mem(size = 2)
	pop cx ;cx = num_2 (size = 1)
	pop ax ;ax = num_1 (size = 0)

	add bx, 80 * 6
;=======================================================;
;Sub ax - bx

	push ax ;saving first num; size = 1

	call Subbery

	pop dx ;dx = num_1; size = 0

	push dx ;saving num_1(size = 1)//
	push cx	;saving num_2(size = 2)//
	push bx ;saving adress of the video_mem (size = 3)

	push ax ;size = 4(saving value)

	call Print_Dec

	pop ax ;size = 3
	push ax ;size = 4

	call Dec_To_Bin

	pop ax ;size = 3

	call Dec_To_Hex
;=======================================================;
;Some workes...
	pop bx ;returning the adress of the video_mem(size = 2)
	pop cx ;cx = num_2 (size = 1)
	pop ax ;ax = num_1 (size = 0)

	add bx, 80 * 6
;=======================================================;
;Mul ax * bx

	push ax ;saving first num; size = 1

	call Multyfruct

	pop dx ;dx = num_1; size = 0

	push dx ;saving num_1(size = 1)//
	push cx	;saving num_2(size = 2)//
	push bx ;saving adress of the video_mem (size = 3)

	push ax ;size = 4(saving value)

	call Print_Dec

	pop ax ;size = 3
	push ax ;size = 4

	call Dec_To_Bin

	pop ax ;size = 3

	call Dec_To_Hex

;=======================================================;
;Some workes...
	pop bx ;returning the adress of the video_mem(size = 2)
	pop cx ;cx = num_2 (size = 1)
	pop ax ;ax = num_1 (size = 0)

	add bx, 80 * 6
;=======================================================;
;Div ax / bx

	push ax ;saving first num; size = 1

	call Divka

	pop dx ;dx = num_1; size = 0

	push dx ;saving num_1(size = 1)//
	push cx	;saving num_2(size = 2)//
	push bx ;saving adress of the video_mem (size = 3)

	push ax ;size = 4(saving value)

	call Print_Dec

	pop ax ;size = 3
	push ax ;size = 4

	call Dec_To_Bin

	pop ax ;size = 3

	call Dec_To_Hex
	
;=======================================================;
	mov ax, 4c00h
	int 21h
;=======================================================;

include lib1.asm
include frame.asm
include oper.asm

;=======================================================;

crlf db 0dh, 0ah, '$'

Enter_first db "Enter the first value: $"

Enter_Second db "Enter the seconf value: $"

first_num:
    max_len_1 db 4
    cur_len_1 db ?
    num_1 db 4 dup('$')

second_num:
    max_len_2 db 4
    cur_len_2 db ?
    num_2 db 4 dup('$')

end start