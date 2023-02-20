.code
;=======================================================;
;-----------------------PRINT_DEC-----------------------;
;use: bx, es, dx, ax
;return decimal number in the video mem
;=======================================================;
Print_Dec		proc
push bx

mov bx, 0b800h
mov es, bx
pop bx

push bx
add bx, 4 ;video_mem shift

print_num_dec:
	mov dl, 10d
	div dl
	add ah, 30h
	mov dl, al
	mov al, ah
	mov ah, 1ch

	mov byte ptr es:[bx], al
	mov byte ptr es:[bx + 1], ah
	sub bx, 2
	
	xor ah, ah
	mov al, dl
	cmp al, 0
	jne print_num_dec

pop bx
	ret
	endp
;-----------------------PRINT_DEC-----------------------;
;=======================================================;

;=======================================================;
;----------------------DEC_T0_BIN-----------------------;
;use: bx, es, dx, ax
;return: ax in binary to the video_mem
;=======================================================;
Dec_To_Bin		proc
push bx

mov bx, 0b800h	;video_mem
mov es, bx	
pop bx

push bx
add bx, 30 ;video_mem shift

print_num_bin: 
	mov dl, 2d		;delitel'
	div dl			;ax / 2
	add ah, 30h		;ah + '0'
	mov dl, al		;keeping al in dl
	mov al, ah		;moving ah to the al
	mov ah, 1ch		;pushing the color
	
	mov byte ptr es:[bx], al		;print the number
	mov byte ptr es:[bx + 1], ah	;print the color
	sub bx, 2						;go left
	
	xor ah, ah		;ah = 0
	mov al, dl		;remaking al
	cmp al, 0		;if al == 0->exit
	jne print_num_bin

pop bx
	ret
	endp

;-----------------------DEC_T0_BIN----------------------;
;=======================================================;



;=======================================================;
;------------------------DEC_TO_HEX---------------------;
;use: bx, es, ax, dx
;return: ax in hex to the video_mem
;=======================================================;

Dec_To_Hex		proc

;From dec to hex
push bx

mov bx, 0b800h	;video_mem
mov es, bx
pop bx

push bx
add bx, 40 ;video_mem shift

print_num: 
	mov dl, 16d		;delitel'
	div dl			;ax / 16
	cmp ah, 9d
	ja letter_symb
	jbe number_symb
next_symb_hex:	
	mov dl, al		;keeping al in dl
	mov al, ah		;moving ah to the al
	mov ah, 1ch		;pushing the color
	
	mov byte ptr es:[bx], al		;print the number
	mov byte ptr es:[bx + 1], ah	;print the color
	sub bx, 2						;go left
	
	xor ah, ah		;ah = 0
	mov al, dl		;remaking al
	cmp al, 0		;if al == 0->exit
	jne print_num
	jmp done

letter_symb:
	add ah, 'A' - 10d 	;become letter
	jmp	next_symb_hex

number_symb:
	add ah, 30h			;become number
	jmp next_symb_hex

done:
	pop bx
	ret
	endp

;------------------------DEC_TO_HEX---------------------;
;=======================================================;
