;======================================================================================================


;============= LIBRER°A PARA LA GESTI¢N DEL CRÇDITO DEL JUGADOR Y DEL POZO DE APUESTAS ================


;======================================================================================================

.8086
.model small
.stack 100h

.data

;========================== CARTELES Y VARIABLES DEL CRÇDITO Y EL POZO ===============================

credito			db 	'…ÕÕÕÕÕÕÕª'
				db	'∫ '  
credito_ASCII	db 	'100 C ∫'
				db	'»ÕÕÕÕÕÕÕº'

pozo			db 	'…ÕÕÕÕÕÕÕª'
				db	'∫ '  
pozo_ASCII		db 	'000 C ∫'
				db	'»ÕÕÕÕÕÕÕº'

.code

;======================== FUNCIONES EXTERNAS ============================================

extrn ASCIIToReg:proc
extrn regToASCII:proc

;=========================== INDICE DE FUNCIONES ====================================================

public Imprimir_credito ;l°nea 69
						;IMPRIME LOS CARTELES DE CRÇDITO Y POZO; NO RECIBE PAR†METROS NI DEVUELVE VALOR ALGUNO

public Recibir_apuesta 	;l°nea 123
						;RECIBE COMO PAR†METRO EN EL STACK UN ENTERO QUE REPRESENTA LA APUESTA
						;PROPUESTA; EVAL£A LA DISPONIBILIDAD DE CRÇDITO PARA REALIZARLA Y, EN CASO 
						;DE SER VALIDADA, MODIFICA LOS CARTELES DE CRÇDITO Y POZO.
						;DEVUELVE EN dx 1 SI LA APUESTA FUE VALIDADA Y 0 SI FUE RECHAZADA

public Resetear_pozo	;l°nea 183
						;NO RECIBE PAR†METROS; INICIALIZA EL 'pozo_ASCII' EN 0

public Evaluar_credito	;l°nea 194
						;NO RECIBE PAR†METROS; DEVUELVE EN dx EL SALDO DE CRÇDITO A FAVOR DEL
						;USUARIO (0 si no queda saldo)

public Pagar_ganancias	;l°nea 208
						;RECIBE EN EL STACK EL PORCENTAJE A PAGAR (0 = devuelve el pozo;
						;1 = 1x1; 2 = 3x2)
						;MODIFICA EL 'credito_ASCII' DE ACUERDO A LAS GANANCIAS OBTENIDAS 
						;Y RESETEA EL POZO

public Evaluacion_doblar_apuesta 	;l°nea 265
									;LEE EL POZO ACTUAL Y LO ENV°A A 'Recibir_apuesta' PARA QUE LO EVAL£E 
									;E INCREMENTE EL POZO EN CASO DE SER POSIBLE. DEVUELVE EN dx EL MISMO 
									;RESULTADO QUE 'Recibir_apuesta' (1 = v†lido; 0 = rechazado)

public Restablecer_credito 		;l°nea 295
								;NO RECIBE PAR†METROS; REINICIALIZA EL CRÇDITO DEL USUARIO EN 100
								;PARA PODER COMENZAR UNA NUEVA PARTIDA

;========================== C¢DIGO DE FUNCIONES ==================================================

Imprimir_credito proc
	push ax
	push bx
	push cx
	push dx
	push bp
	push es
	pushf

	push ds
	pop es ;UBICA AL Extra Segment EN LA POSICI¢N DEL Data Segment
	
	lea bp, credito ;bp TOMAR† EL OFFSET DEL DATO A IMPRIMIR

	mov ah, 13h ;MODO ESCRITURA STRING
	mov al, 01h ;®MODO ESCRITURA?
	mov bh, 00h ;P†GINA
	mov bl, 00000100b ;COLOR
	mov cl, 9 ;LONGITUD DE LA CADENA
	mov dh, 2 ;FILA
	mov dl, 69 ;COLUMNA
imprimir_fila_credito:
	int 10h
	add bp, 9
	inc dh
	cmp dh, 5
	jl imprimir_fila_credito

	lea bp, pozo ;bp TOMAR† EL OFFSET DEL DATO A IMPRIMIR

	mov bl, 00001110b ;COLOR
	mov cl, 9 ;LONGITUD DE LA CADENA
	mov dh, 8 ;FILA
	mov dl, 69 ;COLUMNA
imprimir_fila_pozo:
	int 10h
	add bp, 9
	inc dh
	cmp dh, 11
	jl imprimir_fila_pozo

	popf
	pop es
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax

	ret
Imprimir_credito endp

;=============================================================================================

Recibir_apuesta proc
	push bp
	mov bp, sp
	push ax
	push cx
	pushf

;ALTERA CRÇDITO
	mov ax, ss:[bp + 4]

	push offset credito_ASCII

	call ASCIIToReg

	cmp ax, dx
	ja apuesta_invalida

	sub dx, ax

	push dx
	push offset credito_ASCII

	call regToASCII

;ALTERA POZO
	mov ax, ss:[bp + 4]

	push offset pozo_ASCII

	call ASCIIToReg

	add dx, ax

	push dx
	push offset pozo_ASCII

	call regToASCII

	call Imprimir_credito

	mov dx, 1
	jmp salir_recibir_apuesta

apuesta_invalida:
	mov dx, 0
	mov pozo_ASCII[0], '0'
	mov pozo_ASCII[1], '0'
	mov pozo_ASCII[2], '0'

salir_recibir_apuesta:
	popf
	pop cx
	pop ax
	pop bp

	ret 2
Recibir_apuesta endp

;===================================================================================

Resetear_pozo proc

	mov pozo_ASCII[0], '0'
	mov pozo_ASCII[1], '0'
	mov pozo_ASCII[2], '0'

	ret
Resetear_pozo endp

;======================================================================================

Evaluar_credito proc
	pushf
	
	push offset credito_ASCII

	call ASCIIToReg

	popf

	ret
Evaluar_credito endp

;=========================================================================================

Pagar_ganancias proc
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	pushf

	push offset credito_ASCII

	call ASCIIToReg

	mov bx, dx ;GUARDA EN bx EL VALOR PREVIO DEL CRÇDITO

	push offset pozo_ASCII

	call ASCIIToReg ;EN dx QUEDA EL VALOR ACTUAL DEL POZO (o sea, de la £ltima apuesta)

	add bx, dx ;DEVUELVE EL POZO, ANTES DE CALCULAR GANANCIAS

	cmp word ptr ss:[bp + 4], 0 ;SI EL ARGUMENTO ES IGUAL A 0, SALE DIRECTAMENTE, PORQUE YA DEVOLVI¢ EL POZO
	je salir_pagar_ganancias

	cmp word ptr ss:[bp + 4], 1 ;SI EL ARGUMENTO ES IGUAL A 1, VA A PAGAR 1:1
	je unoXuno

tresXdos: ;SI NO, PAGA 2:3
	mov ax, dx
	mov cl, 2
	div cl

	add dx, ax

unoXuno:
	add bx, dx
salir_pagar_ganancias:
	push bx
	push offset credito_ASCII

	call regToASCII

	call Resetear_pozo
	call Imprimir_credito

	popf
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp

	ret 2
Pagar_ganancias endp

;=================================================================================================

Evaluacion_doblar_apuesta proc
	push cx
	pushf

	push offset pozo_ASCII

	call ASCIIToReg

	mov cx, dx
	push cx

	call Recibir_apuesta

	cmp dx, 0
	jne salir_evaluacion_doblar ;SI LA DUPLICACI¢N ES RECHAZADA, DEBE RESTABLECER EL POZO,
								;PORQUE 'Recibir_apuesta' LO REINICIALIZA
	push cx
	push offset pozo_ASCII

	call regToASCII

salir_evaluacion_doblar:
	popf
	pop cx

	ret
Evaluacion_doblar_apuesta endp

;=================================================================================================

Restablecer_credito proc

	mov credito_ASCII[0], '1'
	mov credito_ASCII[1], '0'
	mov credito_ASCII[2], '0'

Restablecer_credito endp

end