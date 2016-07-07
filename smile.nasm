	BITS 16

start:
	mov ax, 07C0h		; Set up 4K stack space after this bootloader
	add ax, 288		; (4096 + 512) / 16 bytes per paragraph
	mov ss, ax
	mov sp, 4096

	mov ax, 07C0h		; Set data segment to where we're loaded
	mov ds, ax


    call cls
    mov bx, 10h
    call do_smiles

	jmp $			; Jump here - infinite loop!

do_smiles: ; output smile triangle of size stored in BX

.outerloop:
	cmp bx, 0
	je .doneouter
    mov cx, bx
.innerloop:
	cmp cx, 0
	je .doneinner
    call print_smile
    dec cx
    jmp .innerloop
.doneinner:
    call nextLine
    dec bx
    jmp .outerloop
.doneouter:
    ret


print_smile:
	mov si, text_string	; Put string position into SI
	call print_string	; Call our string-printing routine
    ret
	text_string db 'Smile!', 0

print_string:			; Routine: output string in SI to screen
	mov ah, 0Eh		; int 10h 'print char' function

.repeat:
	lodsb			; Get character from string
	cmp al, 0
	je .done		; If char is zero, end of string
	int 10h			; Otherwise, print it
	jmp .repeat

.done:
	ret

nextLine:
    mov ah, 0x2

    mov bh, 0
    mov dl, 0               ; move the cursor to the far left of the
                            ; screen
    inc dh                  ; move the cursor onto the next line
    int 0x10                ; call the BIOS interupt to move the cursor

    ret

cls:
    mov ah, 00h             ; setting video mode kindly clears the screen
    mov al, 02h             ; 02h means 80x25
    int 10h
    ret


	times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
	dw 0xAA55		; The standard PC boot signature
