;======================================================================================================


;=============================== LIBRER¡A GENERAL - FUNCIONES MISCEL NEAS =============================


;======================================================================================================

.8086
.model small
.stack 100h

.data

;========================== LETREROS DEL TAPETE ================================================

mano_crupier db "Mano crupier"
mano_usuario db "Mano "

mano_anonima db "jugador"

letrero_credito db "Cr‚dito"

letrero_apuesta db "Pozo"

.code

;========================== FUNCIONES EXTERNAS ===================================================

extrn Retornar_usuario:proc

;=========================== INDICE DE FUNCIONES ====================================================

public Imprimir_tapete 		;l¡nea 84
							;IMPRIME EL TAPETE VAC¡O; NO RECIBE PAR METROS NI DEVUELVE VALOR ALGUNO

public Cuadro_dialogo		;l¡nea 246
							;RECIBE COMO PAR METROS EN EL STACK, PRIMERO EL OFFSET DE LA CADENA A
							;IMPRIMIR, Y SEGUNDO LA LONGITUD DE LA CADENA A IMPRIMIR
							;IMPRIME LA CADENA SOLICITADA EN LA PARTE INFERIOR DE LA PANTALLA DE JUEGO
							;(texto de interacci¢n con el usuario; impresi¢n de cadena en modo gr fico)

public Borrar_cuadro_dialogo 	;l¡nea 285
								;NO RECIBE PAR METROS; BORRA EL CUADRO DE DI LOGO

public Imprimir_carta_tapada  	;l¡nea 319
								;SIN PAR METROS; IMPRIME UNA FALSA CARTA TAPADA EN LA SEGUNDA POSICI¢N
								;DE LA MANO DEL CRUPIER

public Retraso 				;l¡nea 420
							;GENERA UN RETRASO DE TIEMPO DETERMINADO POR EL USUARIO
							;RECIBE LA EXTENSI¢N DEL RETRASO EN cx (cx = 18 = 1 segundo aprox.) 
							;NO DEVUELVE NADA

public Cajita_musical		;l¡nea 452
							;RECIBE COMO PAR METRO EL OFFSET DE DOS VARIABLES dw; LA PRIMERA CONTIENE
							;LAS NOTAS QUE COMPONEN LA MELOD¡A EN UNA SECUENCIA NUM‚RICA FORMADA POR 
							;LA SUCESIVA DIVISI¢N DE 1.192.500 (frecuencia de base) SOBRE LA FRECUENCIA 
							;DE LA NOTA MUSICAL DESEADA (por ejemplo, 1192500 / 261,626 = 4558 (DO de la
							;cuarta octava)); ESTA PRIMERA VARIABLE DEBE FINALIZAR CON '$' (24h)
							;LA SEGUNDA VARIABLE CONTIENE EL RITMO DE LA MELOD¡A EN UNA SECUENCIA NUM‚RICA
							;QUE EXPRESA LA DURACI¢N DE CADA NOTA EN LA PRIMERA VARIABLE, SEG£N EL PAR METRO
							;DE LA FUNCI¢N 'Retraso' (18 = 1 segundo aprox.)

public Imprimir_cartel		;l¡nea 512
							;RECIBE COMO PAR METRO EN EL STACK, PRIMERO EL OFFSET DEL CARTEL A IMPRIMIR
							;SEGUNDO, SI DEBEN PARPADEAR LAS FILAS 15 Y 16 (0 = no parpadean; <>0 = parpadean) 
							;NO DEVUELVE NADA

public Detencion_espera_tecla	;l¡nea 606
								;OCULTA EL CURSOR Y ESPERA QUE EL USUARIO PRESIONE CUALQUIER TECLA PARA SEGUIR CON LA
								;EJECUCI¢N DEL PROGRAMA
								;NO RECIBE PAR METROS
								;DEVUELVE EN al EL CARACTER DE LA TECLA PRESIONADA POR EL USUARIO

public Imprimir_letrero_inferior	;l¡nea 628
									;RECIBE COMO PAR METRO EN EL STACK, PRIMERO EL OFFSET DEL LETRERO A IMPRIMIR
									;SEGUNDO, SI DEBE PARPADEAR (0 = no parpadea; <>0 = parpadea)
									;IMPRIME EL LETRERO EN LA PARTE INFERIOR DE LA PANTALLA PARA EL MODO TEXTO
									;NO DEVUELVE NADA

;============================ C¢DIGO DE FUNCIONES ==================================================

Imprimir_tapete proc
	push ax
	push bx
	push cx
	push dx
	push si
	push bp
	push es
	pushf

;ESTABLECE COLOR DE FONDO
	mov ah, 0bh
	mov bx, 00h
	int 10h

;MARCO
;L¡NEA SUPERIOR
	mov ah, 0ch
	mov al, 00000111b ;COLOR
	mov bh, 0 ;P GINA
	mov dx, 14 ;POSICI¢N Y
linea_sup:
	mov cx, 540 ;POSICI¢N X
impresion_linea_sup:
	int 10h
	dec cx
	cmp cx, 14
	jge impresion_linea_sup

	inc dx
	cmp dx, 22
	jl linea_sup

;L¡NEA INFERIOR
	mov dx, 300 ;POSICI¢N Y
linea_inf:
	mov cx, 540 ;POSICI¢N X
impresion_linea_inf:
	int 10h
	dec cx
	cmp cx, 14
	jge impresion_linea_inf

	inc dx
	cmp dx, 302
	jl linea_inf

;L¡NEA IZQUIERDA
	mov dx, 16 ;POSICI¢N Y
linea_izq:
	mov cx, 16 ;POSICI¢N X
impresion_linea_izq:
	int 10h
	dec cx
	cmp cx, 14
	jge impresion_linea_izq

	inc dx
	cmp dx, 300
	jl linea_izq

;L¡NEA DERECHA
	mov dx, 16 ;POSICI¢N Y
linea_der:
	mov cx, 540 ;POSICI¢N X
impresion_linea_der:
	int 10h
	dec cx
	cmp cx, 539
	jge impresion_linea_der

	inc dx
	cmp dx, 300
	jl linea_der

;RELLENO
	mov al, 0ah ;CAMBIO COLOR
	mov dx, 16 ;POSICI¢N Y
relleno:
	mov cx, 538 ;POSICI¢N X
impresion_relleno:
	int 10h
	dec cx
	cmp cx, 16
	jge impresion_relleno

	inc dx
	cmp dx, 300
	jl relleno

;CARTELES
;MANO_USUARIO
	push ds
	pop es ;UBICA AL Extra Segment EN LA POSICI¢N DEL Data Segment
	
	lea bp, mano_usuario ;bp TOMAR  EL OFFSET DEL DATO A IMPRIMIR

	mov ah, 13h ;MODO ESCRITURA STRING
	mov al, 01h ;¨MODO ESCRITURA?
	mov bh, 00h ;P GINA
	mov bl, 10000011b ;COLOR
	mov cl, 5 ;LONGITUD DE LA CADENA
	mov dh, 12 ;FILA
	mov dl, 4 ;COLUMNA
	int 10h

	call Retornar_usuario

	mov dl, 9 ;COLUMNA

	cmp cl, 0
	je imprimir_anonimo

	mov bp, si
	jmp salir_impresion_usuario

imprimir_anonimo:
	lea bp, mano_anonima
	mov cl, 7

salir_impresion_usuario:
	int 10h

;MANO_CRUPIER
	lea bp, mano_crupier ;bp TOMAR  EL OFFSET DEL DATO A IMPRIMIR

	mov cl, 12 ;LONGITUD DE LA CADENA
	mov dh, 2 ;FILA
	mov dl, 4 ;COLUMNA
	int 10h

;LETRERO_CREDITO
	lea bp, letrero_credito ;bp TOMAR  EL OFFSET DEL DATO A IMPRIMIR

	mov bl, 00000011b ;CAMBIA EL COLOR, PARA QUE LOS LETREROS NO SE BORREN ENTRE MANO Y MANO
	mov cl, 7 ;LONGITUD DE LA CADENA
	mov dh, 1 ;FILA
	mov dl, 70 ;COLUMNA
	int 10h

;LETRERO_APUESTA
	lea bp, letrero_apuesta ;bp TOMAR  EL OFFSET DEL DATO A IMPRIMIR

	mov cl, 4 ;LONGITUD DE LA CADENA
	mov dh, 7 ;FILA
	mov dl, 70 ;COLUMNA
	int 10h

	popf
	pop es
	pop bp
	pop si
	pop dx
	pop cx
	pop bx
	pop ax

	ret
Imprimir_tapete endp

;==============================================================================================

Cuadro_dialogo proc
	push bp
	mov bp, sp
	push es
	push ax
	push bx
	push cx
	push dx
	pushf

	mov bx, ss:[bp + 6] ;GUARDA EL OFFSET DE LA CADENA A IMPRIMIR
	mov cx, ss:[bp + 4] ;GUARDA LA LONGITUD DE LA CADENA

	push ds
	pop es ;UBICA AL Extra Segment EN LA POSICI¢N DEL Data Segment
	
	mov bp, bx ;bp TOMAR  EL OFFSET DEL DATO A IMPRIMIR

	mov ah, 13h ;MODO ESCRITURA STRING
	mov al, 01h ;¨MODO ESCRITURA?
	mov bh, 00h ;P GINA
	mov bl, 10000110b ;COLOR
	mov dh, 22 ;FILA
	mov dl, 5 ;COLUMNA
	int 10h

	popf
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	pop bp

	ret 4
Cuadro_dialogo endp

;====================================================================================================

Borrar_cuadro_dialogo proc
	push ax
	push bx
	push cx
	push dx
	pushf

	mov ah, 0ch
	mov al, 00000000b ;COLOR
	mov bh, 0 ;P GINA
	mov dx, 306 ;POSICI¢N Y
borrar_dialogo:
	mov cx, 640 ;POSICI¢N X
borrar_dialogo2:
	int 10h
	dec cx
	cmp cx, 0
	jge borrar_dialogo2

	inc dx
	cmp dx, 350
	jl borrar_dialogo

	popf
	pop dx
	pop cx
	pop bx
	pop ax

	ret
Borrar_cuadro_dialogo endp

;======================================================================================================

Imprimir_carta_tapada proc
	push bp
	mov bp, sp
	push es
	push ax
	push bx
	push cx
	push dx
	push si
	pushf

;REVERSO CARTA
;RELLENO
	mov ah, 0ch
	mov al, 00001000b ;COLOR
	mov bh, 0 ;P GINA
	mov dx, 58 ;POSICI¢N Y
relleno_carta:
	mov cx, 72 ;POSICI¢N X
impresion_relleno_carta:
	int 10h
	inc cx
	cmp cx, 126
	jle impresion_relleno_carta

	inc dx
	cmp dx, 148
	jle relleno_carta

;MARCO
;L¡NEA SUPERIOR
	mov al, 10000111b ;COLOR
	mov dx, 60 ;POSICI¢N Y
linea_sup_carta:
	mov cx, 74 ;POSICI¢N X
impresion_linea_sup_carta:
	int 10h
	inc cx
	cmp cx, 124
	jle impresion_linea_sup_carta

	inc dx
	cmp dx, 61
	jle linea_sup_carta

;L¡NEA INFERIOR
	mov dx, 145 ;POSICI¢N Y
linea_inf_carta:
	mov cx, 74 ;POSICI¢N X
impresion_linea_inf_carta:
	int 10h
	inc cx
	cmp cx, 124
	jle impresion_linea_inf_carta

	inc dx
	cmp dx, 146
	jle linea_inf_carta

;L¡NEA IZQUIERDA
	mov dx, 62 ;POSICI¢N Y
linea_izq_carta:
	mov cx, 74 ;POSICI¢N X
impresion_linea_izq_carta:
	int 10h
	inc cx
	cmp cx, 75
	jle impresion_linea_izq_carta

	inc dx
	cmp dx, 144
	jle linea_izq_carta

;L¡NEA DERECHA
	mov dx, 62 ;POSICI¢N Y
linea_der_carta:
	mov cx, 123 ;POSICI¢N X
impresion_linea_der_carta:
	int 10h
	inc cx
	cmp cx, 124
	jle impresion_linea_der_carta

	inc dx
	cmp dx, 144
	jle linea_der_carta

	popf
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	pop bp

	ret
Imprimir_carta_tapada endp

;==========================================================================================================

Retraso proc ;cx = 18 = 1 segundo (aprox)
	push ax
	push cx
	push dx
	pushf

	mov ah, 2ch ;SERVICIO PARA LEER EL TIMER DEL SISTEMA
ciclos_solicitados:
	push cx ;GUARDA EL CONTADOR PORQUE ES ALTERADO POR EL SERVICIO 2ch
	int 21h ;COPIA EL TIMER DEL SISTEMA

	mov al, dl ;GUARDA EN al LOS CENTISEGUNDOS

vueltas_retraso:
	int 21h ;VUELVE A COPIAR EL TIMER DEL SISTEMA
	cmp al, dl ;CHEQUEA SI LOS CENTISEGUNDOS CAMBIARON
	jne siguiente_ciclo ;SI CAMBIARON, VA AL SIGUIENTE CICLO
	jmp vueltas_retraso ;SI NO, SIGUE CHEQUEANDO EL CAMBIO DE LOS CENTISEGUNDOS
siguiente_ciclo:
	pop cx ;RECUPERA EL CONTADOR
	loop ciclos_solicitados ;REPITE EL CICLO TANTAS VECES COMO SE INDIC¢ POR PAR METRO

	popf
	pop dx
	pop cx
	pop ax

	ret
Retraso endp

;============================================================================================

Cajita_musical proc
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	pushf

	mov si, ss:[bp + 6]
 	mov di, ss:[bp + 4]

melodia:

	mov bx, [si] ;NOTA (frecuencia de entrada del altavoz (1.192.500) / frecuencia nota musical;
						;por ejemplo, para el DO de la octava 4, 1192599 / 261,626 = 4558)
	mov dx, [di] ;DURACI¢N

	;ENCIENDE EL ALTAVOZ
	mov al, bl
    out 42h, al
    mov al, bh
    out 42h, al
    in al, 61h
    or al, 00000011b
    out 61h, al

    mov cx, dx ;EXTIENDE LA DURACI¢N DE LA NOTA SEG£N INDICADO EN LA VARIABLE RITMO
    call Retraso

    ;APAGA EL ALTAVOZ
    in  al, 61h
    and al, 11111100b
    out 61h, al

    mov cx, 1 ;PEQUE¤O RETRASO PARA SEPARAR LAS NOTAS UNA DE OTRA
    call Retraso

    add si, 2 ;INCREMENTO LOS CONTADORES DE LA MELOD¡A Y EL RITMO
	add di, 2
    
    cmp word ptr [si], 24h ;SI ALCANZ¢ EL FIN DE LA VARIABLE MELOD¡A, SALE
    jne melodia

    popf
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp

    ret 4
Cajita_musical endp

;==================================================================================================

Imprimir_cartel proc
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push si
	pushf

	mov si, ss:[bp + 6]
	mov dh, 4 ;FILA INICIAL
	mov dl, 12 ;COLUMNA INICIAL
	mov cx, 1 ;CANTIDAD DE VECES QUE ESCRIBE EL CARACTER

imprime_cartel:
	mov ah, 2 ;ASIGNA POSICI¢N AL CURSOR
	mov bh, 0 ;NRO DE P GINA
	int 10h

	mov ah, 09h ;ESCRIBE EN LA POSICI¢N DEL CURSOR
	mov al, [si] ;CARACTER

;EVAL£A LAS CONDICIONES DE COLOR Y PARPADEO

	cmp al, 03h
	je es_rojo
	cmp al, 04h
	je es_rojo
	cmp al, 05h
	je es_negro
	cmp al, 06h
	je es_negro

	cmp word ptr ss:[bp + 4], 0 ;EVAL£A EL SEGUNDO PAR METRO; SI ES 0, NO DEBE HABER PARPADEO
	je no_parpadea

	cmp dh, 16;SI NO, EVAL£A LAS CONDICIONES PARA QUE S¢LO PARPADEEN LAS L¡NEAS 15 Y 16
	je casi_parpadea
	cmp dh, 17
	je casi_parpadea
	jmp no_parpadea
casi_parpadea:
	cmp dl, 14
	ja casi_parpadea2
	jmp no_parpadea
casi_parpadea2:
	cmp dl, 65
	jb parpadea
	jmp no_parpadea
parpadea:
	mov bl, 11100000b ;COLOR PARPADEA
	jmp color_establecido
no_parpadea:
	mov bl, 01101111b ;COLOR SIN PARPADEAR
	jmp color_establecido

es_rojo:
	mov bl, 01100100b ;ROJO
	jmp color_establecido

es_negro:
	mov bl, 01100000b ;NEGRO
	
color_establecido:
	int 10h

	inc si ;DESPLAZA EL PUNTERO A LA VARIABLE DEL CARTEL A IMPRIMIR
	inc dl ;MUEVE LA COLUMNA DEL CURSOR
	cmp dl, 68 ;SI ALCANZA LA COLUMNA 68, DEBE BAJAR DE FILA
	ja bajar_fila
	jmp imprime_cartel

bajar_fila:
	mov dl, 12 ;REINICIALIZA LA COLUMNA
	inc dh	;INCREMENTA LA FILA
	cmp dh, 19 ;SI ALCANZ¢ LA FILA 19, TERMINA LA IMPRESI¢N
	ja salir_impresion_cartel
	jmp imprime_cartel

salir_impresion_cartel:
	popf
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp

	ret 4
Imprimir_cartel endp

;==============================================================================================================

Detencion_espera_tecla proc
	push bx
	push dx
	pushf

	mov ah, 2 ;ASIGNA POSICI¢N AL CURSOR
	mov bh, 0 ;NRO DE P GINA
	mov dh, 25 ;FILA INICIAL
	mov dl, 80 ;COLUMNA INICIAL
	int 10h
	mov ah, 7
	int 21h

	popf
	pop dx
	pop bx

	ret
Detencion_espera_tecla endp

;=============================================================================================================

Imprimir_letrero_inferior proc
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	pushf

	mov si, ss:[bp + 6]
	mov dh, 22 ;FILA INICIAL
	mov dl, 15 ;COLUMNA INICIAL
	mov cx, 1 ;CANTIDAD DE VECES QUE ESCRIBE EL CARACTER

imprime_letrero:
	mov ah, 2 ;ASIGNA POSICI¢N AL CURSOR
	mov bh, 0 ;NRO DE P GINA
	int 10h

	mov ah, 09h ;ESCRIBE EN LA POSICI¢N DEL CURSOR
	mov al, [si] ;CARACTER

;EVAL£A LAS CONDICIONES DE COLOR Y PARPADEO

	cmp word ptr ss:[bp + 4], 0 ;EVAL£A EL SEGUNDO PAR METRO; SI ES 0, NO DEBE HABER PARPADEO
	je no_parpadea_letrero

	mov bl, 10000110b ;COLOR PARPADEA
	jmp color_establecido_letrero
no_parpadea_letrero:
	mov bl, 00000110b ;COLOR SIN PARPADEAR
	jmp color_establecido_letrero
	
color_establecido_letrero:
	int 10h

	inc si ;DESPLAZA EL PUNTERO A LA VARIABLE DEL CARTEL A IMPRIMIR
	inc dl ;MUEVE LA COLUMNA DEL CURSOR
	
	cmp byte ptr [si], 24h
	je salir_impresion_letrero
	jmp imprime_letrero

salir_impresion_letrero:
	popf
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp

	ret 4
Imprimir_letrero_inferior endp

end