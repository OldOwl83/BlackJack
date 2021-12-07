;======================================================================================================


;====== LIBRER°A PARA LA GESTI¢N DEL MAZO DE CARTAS (funci¢n random) Y LA EVALUACI¢N DE LAS MANOS =====


;======================================================================================================

.8086
.model small
.stack 100h

.data

;======================= VARIABLES PARA LA GESTI¢N DEL MAZO ========================================
mazo db 24 dup(0)

nro_carta_usuario dw 0
nro_carta_crupier dw 0

numero_carta dw "  "
palo_carta db 03h ;DEL 3 AL 6 (coraz¢n, diamante, trÇbol y pica)

;====================== COORDENADAS PARA LA IMPRESI¢N DE LAS CARTAS ================================

referencia_fondo_X dw 0 ;REFERENCIA_FONDO_X = REFERENCIA_CARAC_X * 8
referencia_fondo_Y dw 0 ;REFERENCIA_FONDO_Y = REFERENCIA_CARAC_Y * 14

referencia_carac_X db 0 ;POSICIONES DE LAS CARTAS SOBRE EL EJE DE LAS X: 0 Y M£LTIPLOS DE 7 
						;(m£ltiplos de 5 para superponer)
referencia_carac_Y db 0 ;POSICIONES DE LAS CARTAS SOBRE EL EJE DE LAS Y:
							;1 PARA EL CRUPIER
							;11 PARA EL USUARIO

.code

;======================= INDICE DE FUNCIONES =======================================================

public Barajar_mazo		;l°nea 78
						;LLENA LA VARIABLE INTERNA 'mazo' CON 24 CARTAS DIFERENTES, ELEGIDAS 
						;ALEATORIAMENTE (las cartas son representadas con los enteros 1-52)

;Control_repetici¢n_carta (NO PUBLIC) 	;l°nea
				 						;RECIBE COMO PARAMETRO EN EL STACK EL N£MERO DE CARTA A CONTROLAR
				 						;DEVUELVE 1 EN dx SI LA CARTA ES V†LIDA (no est† en el 'mazo'), 
										;O 0 SI LA MISMA YA SE ENCUENTRA EN EL 'mazo'

public Servir_carta		;l°nea 194
						;IMPRIME LA SIGUIENTE CARTA DEL 'mazo' QUE CORRESPONDE A CADA JUGADOR
						;EN CADA MANO, Y LLEVA EL REGISTRO DE LA £LTIMA CARTA SERVIDA A CADA UNO
						;('nro_carta_usuario', 'nro_carta_crupier'); PARA EL USUARIO RECOGE LAS 
						;CARTAS DE LAS POSICIONES 0-11 DEL 'mazo', Y PARA EL CRUPIER DE LAS 12-23.
						;RECIBE COMO PAR†METRO EN EL STACK SI LA CARTA DEBE SER SERVIDA 
						;AL USUARIO (<> 0) O AL CRUPIER (0);
						;MANEJA LAS VARIABLES INTERNAS: 'numero_carta', 'palo_carta', 
						;'referencia_fondo_X', 'referencia_fondo_Y', 'referencia_carac_X', 
						;'referencia_carac_Y', 'nro_carta_usuario', 'nro_carta_crupier'
						;LAS DOS £LTIMAS SIRVEN DE REFERENCIA A LA FUNCI¢N 'Evaluar_mano'

public Evaluar_mano 	;l°nea 470
						;RECIBE COMO PAR†METROS EN EL STACK SI SE DEBE EVALUAR LA MANO DEL 
						;USUARIO (<> 0) O LA DEL CRUPIER (0)
						;EVAL£A EL RESULTADO ALCANZADO POR LA MANO INDICADA HASTA EL MOMENTO 
						;EN QUE SE LA LLAMA; DEVUELVE LA EVALUACI¢N EN dx (0 = se pas¢ de los 21
						;40 = BlackJack; 1-21 = suma de las cartas obtenidas hasta el momento)
						;Y EN cx DECLARA SI LA MANO ES DURA O BLANDA (0 = dura; Nro positivo = cantidad 
						;de ases que valen once)
						;ESTA £LTIMA INDICACI¢N S¢LO SIRVE PARA CUANDO EL CRUPIER SE PLANTA PORQUE
						;SUPER¢ LOS 17, PERO PIERDE CON UNA MANO BLANDA; EN TAL CASO, SIGUE SACANDO
						;HASTA GANAR O SUPERAR LOS 17 CON UNA MANO DURA

public Reiniciar_mazo	;l°nea 598
						;NO RECIBE PAR†METROS. INICIALIZA TODAS LAS VARIABLES DE ESTA LIBRER°A
						;PARA COMENZAR UNA MANO NUEVA

;============================= C¢DIGO DE FUNCIONES ==================================================

Barajar_mazo proc
	push ax ;RESGUARDA EL ENTORNO
	push bx
	push cx
	push dx
	push di
	push si
	pushf

	lea si, mazo ;GUARDA EN si EL OFFSET DEL 'mazo', PARA PODER RECORRERLO

	mov ah, 2ch ;LEE EL TIMER (en dh quedan los segundos y en dl las centÇsimas de segundo)
	int 21h		;LA FUNCION USARA DE SEMILLA ESOS DOS NUMEROS TOMADOS COMO UN WORD (dx), Y A LAS UNIDADES DEL MISMO

	mov bx, dx ;EN bx SE CONSERVA LA SEMILLA MODIFICADA A LO LARGO DE TODO EL PROCESO

	mov ax, bx ;DIVIDE LA SEMILLA POR 10, PARA OBTENER SUS UNIDADES
	xor dx, dx ;INICIALIZA dx PORQUE INTERVIENE EN LA DIVISION
	mov cx, 10
	div cx
	mov dh, 0 ;SE CONSERVA EN di LAS UNIDADES DE LA SEMILLA, QUE TAMBIEN SE IRAN MODIFICANDO
	mov di, dx 

	mov cx, 24 ;CONTADOR PARA EL CICLO GENERAL, QUE GRABA 24 CARTAS DIFERENTES EN LA VARIABLE DESTINO

reparto:
	mov ax, bx ;GUARDA LA SEMILLA EN ax PARA PODER XOREARLA CONSIGO MISMA SHIFTEADA
	ror bx, 8 ;SHIFTEA LA SEMILLA DE MANERA ROTATIVA (Çste es el gran truco para obtener enteros imprevisibles)

	xor bx, ax ;LA XOREA CON SU VERSION NO SHIFTEADA

	add bx, di ;LE SUMA LAS UNIDADES DE LA SEMILLA ORIGINAL, PARA SEGUIR VARI†NDOLA
				;(si no se hace esta adici¢n, la funci¢n pincha, tanto en la versi¢n Assembler
				; como la hecha en C; es porque evita que la secuencia se repita peri¢dicamente
				;lo que producir°a un ciclo infinito)
	inc di ;INCREMENTA LAS UNIDADES PARA QUE LA VARIACION SEA SIEMPRE DISTINTA

	mov ax, bx ;LA SEMILLA MODIFICADA SE MANTIENE EN bx HASTA EL PROXIMO CICLO, DONDE SE SEGUIRA MODIFICANDO
				;LA COPIA EN ax PARA PODER DIVIDIRLA Y OBTENER EN EL RESTO UN ENTERO ENTRE 0 Y 51
	xor dx, dx ;INICIALIZA dx PORQUE INTERVIENE EN LA DIVISION
	push cx ;GUARDA EL CONTADOR Y USA cx PARA LA DIVISION
	mov cx, 52
	div cx
	inc dx ;INCREMENTA EL RESULTADO PARA OBTENER UN ENTERO ENTRE 1 Y 52 (se intent¢ manejar
			;un rango 0-51, pero por alguna raz¢n la frecuencia de los ases se volv°a
			;baj°sima, y era casi imposible que salieran en primer o segundo lugar; o sea
			;el BlackJack se volv°a muy improbable)
	pop cx ;RECUPERA EL CONTADOR

	mov dh, 0 ;PREPARA EL CANDIDATO OBTENIDO PARA PUSHEARLO A LA FUNCION DE Control_repeticion_carta
	mov ax, dx ;GUARDA EL CANDIDATO EN ax PORQUE, EN CASO DE SER VALIDADO, DEBE GUARDARLO EN LA VARIABLE DESTINO
				;(dx SERA ALTERADO POR Control_repeticion_carta)
	
	push dx ;PRIMER PARAMETRO PARA Control_repeticion_carta

	call Control_repeticion_carta

	cmp dx, 1 ;SI Control_repeticion_carta VALIDA A LA CONDIDATA, SALTA A GUARDARLA EN LA VARIABLE DESTINO
	je servir_carta1

	jmp reparto ;SI NO, VUELVE A BUSCAR OTRO RANDOM

servir_carta1:
	mov [si], ax
	inc si

	loop reparto
	
	popf
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax

	ret
Barajar_mazo endp

;=================================================================================================

Control_repeticion_carta proc
	push bp ;RESGUARDA EL ENTORNO
	mov bp, sp
	push bx
	push cx
	pushf

	mov dx, ss:[bp + 4] ;GUARDA EN dx LA CARTA A CONTROLAR
	lea bx, mazo ;GUARDA EN bx EL OFFSET DEL 'mazo' DE CARTAS
	mov cx, 24 ;USA cx COMO CONTADOR PARA EL LOOP QUE RECORRE LAS 24 POSICIONES DEL MAZO

Recorrer_mazo:
	cmp dl, [bx] ;COMPARA EL VALOR DE LA CARTA A CONTROLAR CON EL VALOR DE CADA POSICION DEL MAZO
	je carta_invalida ;SI HAY IGUALDAD, SALTA A LA INVALIDACION

	inc bx ;SI NO, INCREMENTA bx Y SIGUE CON EL LOOP
	loop Recorrer_mazo

	mov dx, 1 ;SI TERMINA EL LOOP SIN SALTAR A LA INVALIDACION, LA CARTA ES VALIDA
	jmp terminar_control_repeticion

carta_invalida:
	mov dx, 0

terminar_control_repeticion:
	popf
	pop cx
	pop bx
	pop bp

	ret 2
Control_repeticion_carta endp

;===============================================================================================

Servir_carta proc
	push bp
	mov bp, sp
	push es
	push ax
	push bx
	push cx
	push dx
	push si
	pushf
			
	cmp word ptr ss:[bp + 4], 0 ;EVAL£A SI LA CARTA ES PARA EL CRUPIER O PARA EL USUARIO
	je para_crupier

;UBICA LA CARTA PARA EL USUARIO
	mov referencia_carac_Y, 11 ;COORDENADA y
	mov referencia_fondo_Y, 154

	inc nro_carta_usuario ;INCREMENTA EL NRO DE CARTA ANTICIPADAMENTE, PARA QUE NO SE QUEDE
							;DESFASADO CUANDO LLAME A 'Evaluar_mano' (para calcular la
							;coordenada x necesito que sea distinto de 0)
	mov ax, nro_carta_usuario ;CALCULA LA POSICI¢N DE LA COORDENADA x PARA LOS CARACTERES
	mov cx, 5
	mul cx
	sub ax, 5
	mov referencia_carac_X, al
	mov cx, 8 ;CALCULA LA POSICI¢N DE LA COORDENADA x PARA EL FONDO DE LA CARTA
	mul cx
	mov referencia_fondo_X, ax

	mov si, nro_carta_usuario ;APUNTA si A LA POSICI¢N DEL MAZO QUE CORRESPONDE A LA CARTA 
	dec si 						;DEL USUARIO

	jmp datos_carta
;UBICA LA CARTA PARA EL CRUPIER
para_crupier:
	mov referencia_carac_Y, 1 ;COORDENADA y
	mov referencia_fondo_Y, 14

	inc nro_carta_crupier ;INCREMENTA EL NRO DE CARTA ANTICIPADAMENTE, PARA QUE NO SE QUEDE
							;DESFASADO CUANDO LLAME A 'Evaluar_mano' (para calcular la
							;coordenada x necesito que sea distinto de 0)
	mov ax, nro_carta_crupier ;CALCULA LA POSICI¢N DE LA COORDENADA x PARA LOS CARACTERES
	;xor ah, ah
	mov cx, 5
	mul cx
	sub ax, 5
	mov referencia_carac_X, al
	mov cx, 8 ;CALCULA LA POSICI¢N DE LA COORDENADA x PARA EL FONDO DE LA CARTA
	mul cx
	mov referencia_fondo_X, ax

	mov si, 11					;APUNTA si A LA POSICI¢N DEL MAZO QUE CORRESPONDE A LA CARTA
	add si, nro_carta_crupier	;DEL CRUPIER

datos_carta:
	mov al, mazo[si]
	dec al ;DECREMENTA LA CARTA OBTENIDA, PARA QUE EL RANGO SEA 0-51, Y FUNCIONE LA DIVISI¢N
	xor ah, ah
	xor dx, dx
	mov cx, 13
	div cx 
	mov palo_carta, al ;ALMACENA EL PALO EN LA VARIABLE CORRESPONDIENTE
	add palo_carta, 3 ;LE SUMA TRES PARA QUE COINCIDA CON EL ASCII DEL PALO

	cmp dx, 0
	je es_as
	cmp dx, 9
	je es_diez
	cmp dx, 10
	je es_jota
	cmp dx, 11
	je es_qu
	cmp dx, 12
	je es_ka
	mov numero_carta, dx ;ALMACENA EL NRO DE LA CARTA, SI COINCIDE CON EL ENTERO
	inc numero_carta ;LO INCREMENTA PARA QUE NO QUEDE DESPLAZADO EN UNO
	add numero_carta, 30h ;LO CONVIERTE EN ASCII
	jmp impresion_carta

es_as:
	mov numero_carta, 'A' ;ALMACENA EL NRO DE LA CARTA, DE ACUERDO A LOS SIGNOS ESPECIALES
	jmp impresion_carta
es_diez:
	mov numero_carta, '01'
	jmp impresion_carta
es_jota:
	mov numero_carta, 'J'
	jmp impresion_carta
es_qu:
	mov numero_carta, 'Q'
	jmp impresion_carta
es_ka:
	mov numero_carta, 'K'
	jmp impresion_carta

;IMPRESI¢N DE LA CARTA
impresion_carta:
;FONDO CARTA
;RELLENO
	mov ah, 0ch
	mov al, 00001111b ;COLOR
	mov bh, 0 ;P†GINA
	mov dx, 44 ;POSICI¢N Y
relleno_carta:
	add dx, referencia_fondo_Y
	mov cx, 32 ;POSICI¢N X
impresion_relleno_carta:
	add cx, referencia_fondo_X
	int 10h
	inc cx
	sub cx, referencia_fondo_X
	cmp cx, 86
	jle impresion_relleno_carta

	inc dx
	sub dx, referencia_fondo_Y
	cmp dx, 134
	jle relleno_carta

;MARCO
;L°NEA SUPERIOR
	mov al, 10000111b ;COLOR
	mov dx, 46 ;POSICI¢N Y
linea_sup_carta:
	add dx, referencia_fondo_Y
	mov cx, 34 ;POSICI¢N X
impresion_linea_sup_carta:
	add cx, referencia_fondo_X
	int 10h
	inc cx
	sub cx, referencia_fondo_X
	cmp cx, 84
	jle impresion_linea_sup_carta

	inc dx
	sub dx, referencia_fondo_Y
	cmp dx, 47
	jle linea_sup_carta

;L°NEA INFERIOR
	mov dx, 131 ;POSICI¢N Y
linea_inf_carta:
	add dx, referencia_fondo_Y
	mov cx, 34 ;POSICI¢N X
impresion_linea_inf_carta:
	add cx, referencia_fondo_X
	int 10h
	inc cx
	sub cx, referencia_fondo_X
	cmp cx, 84
	jle impresion_linea_inf_carta

	inc dx
	sub dx, referencia_fondo_Y
	cmp dx, 132
	jle linea_inf_carta

;L°NEA IZQUIERDA
	mov dx, 48 ;POSICI¢N Y
linea_izq_carta:
	add dx, referencia_fondo_Y
	mov cx, 34 ;POSICI¢N X
impresion_linea_izq_carta:
	add cx, referencia_fondo_X
	int 10h
	inc cx
	sub cx, referencia_fondo_X
	cmp cx, 35
	jle impresion_linea_izq_carta

	inc dx
	sub dx, referencia_fondo_Y
	cmp dx, 130
	jle linea_izq_carta

;L°NEA DERECHA
	mov dx, 48 ;POSICI¢N Y
linea_der_carta:
	add dx, referencia_fondo_Y
	mov cx, 83 ;POSICI¢N X
impresion_linea_der_carta:
	add cx, referencia_fondo_X
	int 10h
	inc cx
	sub cx, referencia_fondo_X
	cmp cx, 84
	jle impresion_linea_der_carta

	inc dx
	sub dx, referencia_fondo_Y
	cmp dx, 130
	jle linea_der_carta

;IMPRESI¢N DE LOS N£MEROS
	push ds
	pop es ;UBICA AL Extra Segment EN LA POSICI¢N DEL Data Segment
	
	lea bp, numero_carta ;bp TOMAR† EL OFFSET DEL DATO A IMPRIMIR

	mov ah, 13h ;MODO ESCRITURA STRING
	mov al, 081h ;®MODO ESCRITURA?
	mov bh, 00h ;P†GINA
	mov bl, 10001111b ;COLOR
	mov cl, 2 ;LONGITUD DE LA CADENA
	mov dh, referencia_carac_Y ;ESTABLECE LAS COORDENADAS DE REFERENCIA
	mov dl, referencia_carac_X
	add dh, 4 ;DESPLAZAMIENTO FILA
	add dl, 5 ;DESPLAZAMIENTO COLUMNA
	int 10h

	mov dh, referencia_carac_Y ;ESTABLECE LAS COORDENADAS DE REFERENCIA
	mov dl, referencia_carac_X
	add dh, 8 ;DESPLAZAMIENTO FILA
	cmp numero_carta, '01' ;SI EL NRO ES 10, DEBE CORRERLO EN LA 
							;IMPRESI¢N INFERIOR
	je desplazar_columna
	add dl, 9 ;DESPLAZAMIENTO COLUMNA
	int 10h
	jmp pasar_impr_palo

desplazar_columna:
	add dl, 8 ;DESPLAZAMIENTO COLUMNA
	int 10h

pasar_impr_palo:
;IMPRESI¢N DEL PALO
	lea bp, palo_carta ;bp TOMAR† EL OFFSET DEL DATO A IMPRIMIR

;BUSCO COLOR
	cmp palo_carta, 03h
	je palo_rojo
	cmp palo_carta, 04h
	je palo_rojo

	mov bl, 10001111b ;COLOR
	jmp impresion_palo
palo_rojo:
	mov bl, 10001011b ;COLOR
impresion_palo:
	mov cl, 1 ;LONGITUD DE LA CADENA
	mov dh, referencia_carac_Y ;ESTABLECE LAS COORDENADAS DE REFERENCIA
	mov dl, referencia_carac_X
	add dh, 5 ;DESPLAZAMIENTO FILA
	add dl, 6 ;DESPLAZAMIENTO COLUMNA
	int 10h
	mov dh, referencia_carac_Y ;ESTABLECE LAS COORDENADAS DE REFERENCIA
	mov dl, referencia_carac_X
	add dh, 5 ;DESPLAZAMIENTO FILA
	add dl, 8 ;DESPLAZAMIENTO COLUMNA
	int 10h
	mov dh, referencia_carac_Y ;ESTABLECE LAS COORDENADAS DE REFERENCIA
	mov dl, referencia_carac_X
	add dh, 7 ;DESPLAZAMIENTO FILA
	add dl, 6 ;DESPLAZAMIENTO COLUMNA
	int 10h
	mov dh, referencia_carac_Y ;ESTABLECE LAS COORDENADAS DE REFERENCIA
	mov dl, referencia_carac_X
	add dh, 7 ;DESPLAZAMIENTO FILA
	add dl, 8 ;DESPLAZAMIENTO COLUMNA
	int 10h

	popf
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	pop bp

	ret 2
Servir_carta endp

;===========================================================================================

Evaluar_mano proc
	push bp
	mov bp, sp
	push ax
	push bx
	push si
	push di
	pushf

	mov bx, 0 ;REGISTRO DONDE SE ACUMULA LA SUMA TOTAL
	mov di, 0 ;REGISTRO DONDE SE CUENTA LA CANTIDAD DE ASES OBTENIDOS
	mov cx, 13 ;DIVISOR PARA OBTENER EL VALOR DE LA CARTA EN EL RESTO

;si = °NDICE PARA RECORRER LAS CARTAS OBTENIDAS (se detiene cuando alcanza el 'nro_carta_...'
;que corresponde a cada jugador)
	cmp word ptr ss:[bp + 4], 0 ;SI SE INDIC¢ EVALUAR LA MANO DEL CRUPIER, SALTA A CORREGIR EL °NDICE
	je evaluar_mano_crupier

	mov si, 0 ;SI NO, APUNTA EL °NDICE A LA PRIMERA POSICI¢N DEL MAZO 
	mov dx, nro_carta_usuario ;A TRAVêS DE dx PUSHEA LA POSICI¢N OBJETIVO DEL °NDICE, DONDE
								;DEBE TERMINAR LA SUMA
	jmp sumar_cartas

evaluar_mano_crupier:
	mov si, 12 ;SI LA MANO ES DEL CRUPIER, EL °NDICE EMPIEZA A RECORRER
				;DESDE LA POSICI¢N 12
	mov dx, 12 ;A TRAVêS DE dx PUSHEA LA POSICI¢N OBJETIVO DEL °NDICE, DONDE DEBE TERMINAR LA SUMA
	add dx, nro_carta_crupier

sumar_cartas:
	push dx ;PUSHEA LA POSICI¢N OBJETIVO
	xor ax, ax
	mov al, mazo[si] ;RECUPERA CADA CARTA A EVALUAR
	dec al ;DECREMENTA EL N£MERO DE LA CARTA PARA VOLVER AL RANGO 0-51, Y QUE LA DIVISI¢N FUNCIONE
	xor dx, dx ;DIVIDE POR 13 PARA OBTENER EL N£MERO EN EL RESTO (dx)
	div cx

	cmp dx, 0 ;COMPARA EL RESTO OBTENIDO PARA DETECTAR SU VALOR
	je vale_as
	cmp dx, 9
	je vale_diez
	cmp dx, 10
	je vale_diez
	cmp dx, 11
	je vale_diez
	cmp dx, 12
	je vale_diez

	inc dx ;SI NO ES NI AS, NI 10, NI FIGURA, LA INCREMENTA PARA SUMAR EL VALOR DE SU N£MERO
	add bx, dx ;SUMA EN EL ACUMULADOR
	jmp seguir_sumando_cartas

vale_as: ;SI ES UN AS, LO GUARDA PARA EVALUARLO AL FINAL
	inc di
	jmp seguir_sumando_cartas

vale_diez: ;SI ES 10 O FIGURA, SUMA 10
	add bx, 10

seguir_sumando_cartas:
	pop dx ;RECUPERA LA POSICI¢N OBETIVO DEL °NDICE
	inc si ;INCREMENTA EL °NDICE PARA SEGUIR RECORRIENDO EL MAZO
	cmp si, dx ;SI EL °NDICE ALCANZA EL OBJETIVO, DEJA DE EVALUAR LAS CARTAS
	jl sumar_cartas

;EVALUAR ASES
	mov cx, di ;EN cx CONTABILIZA LA CANTIDAD DE ASES QUE VALEN ONCE
				;SI AL MENOS QUEDA UNO QUE VALGA ONCE, LA MANO ES BLANDA

evaluar_ases:
	cmp di, 0 ;SI QUEDAN CERO ASES, SALE DE LA EVALUACI¢N
	je salir_evaluar_ases

	add bx, 11 ;SI NO, SUMA 11
	cmp bx, 21 ;SI DESPUÇS DE SUMAR 11 NO SUPERA LOS 21, VA AL DECREMENTO DE di PARA 
				;SEGUIR EVALUANDO EL RESTO DE ASES
	jle vale_once

	sub bx, 10 ;EN CAMBIO, SI SUPERA LOS 21, LE RESTA 10 (o sea, pasa a valer 1)
	dec cx ;CADA VEZ QUE DISMINUYO EL VALOR DE UN AS, DESCUENTA LOS ASES QUE VALEN ONCE EN cx

vale_once:
	dec di ;DECREMENTA LA CANTIDAD DE ASES RESTANTES Y VUELVO A LA EVALUACI¢N
	
	jmp evaluar_ases

salir_evaluar_ases:
;EVALUACI¢N DE LOS RESULTADOS
	cmp bx, 21 ;SI ES MENOR O IGUAL A 21, SIGUE EVALUANDO
	jle sigue_vivo

	mov dx, 0 ;SI NO, DEVUELVE 0, INDICANDO QUE SE PAS¢
	jmp salir_evaluar_mano_usuario

sigue_vivo:
	cmp bx, 21 ;VUELVE A COMPARAR CON 21
	jne devuelve_suma ;SI NO ES IGUAL, DEBE DEVOLVER LA SUMA OBTENIDA
	cmp dx, 2 ;SI ES IGUAL, EVAL£A SI ES BLACKJACK (si el objetivo era 2, es BJ del usuario)
	jne posible_BJ_crupier ;SI EL OBJETIVO ERA DISTINTO DE 2, EVAL£A SI ES BLACKJACK DEL CRUPIER

	mov dx, 40 ;EN CAMBIO, SI EL OBJETIVO ERA IGUAL A 2, SIGNIFICA QUE S¢LO SAC¢
				;DOS CARTAS PARA EL USUARIO, POR LO QUE TIENE BLACKJACK (devuelve 40 para indicarlo)
	jmp salir_evaluar_mano_usuario

posible_BJ_crupier:
	cmp dx, 14 ;SI EL OBJETIVO ERA DISTINTO DE 14, EL CRUPIER NO TIENE BLACKJACK
	jne devuelve_suma

	mov dx, 40 ;EN CAMBIO, SI ERA 14, SIGNIFICA QUE S¢LO SAC¢ DOS CARTAS PARA EL CRUPIER 
				;POR LO QUE TIENE BLACKJACK (devuelve 40 para indicarlo)
	jmp salir_evaluar_mano_usuario

devuelve_suma:
	mov dx, bx ;GUARDA LA SUMA EN EL REGISTRO DE RETORNO

salir_evaluar_mano_usuario:
	popf
	pop di
	pop si
	pop bx
	pop ax
	pop bp

	ret 2
Evaluar_mano endp

;==================================================================================================

Reiniciar_mazo proc

	mov referencia_fondo_X, 0
	mov referencia_fondo_Y, 0
	mov referencia_carac_X, 0
	mov referencia_carac_Y, 0

	mov nro_carta_usuario, 0
	mov nro_carta_crupier, 0

	ret
Reiniciar_mazo endp

end