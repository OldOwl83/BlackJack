;======================================================================================================


;================================ LIBRER¡A GENERAL - FUNCIONES B SICAS (I/O) ==========================


;======================================================================================================

.8086
.model small
.stack 100h

.data

;=========================== CARTELES DE ERROR ========================================================

variable_no_numerica db 0dh, 0ah, "La variable indicada no es num‚rica.", 0dh, 0ah, 24h

entero_demasiado_alto db 0dh, 0ah, "El entero pasado por par metro es demasiado grande para ser almacenado "
					  db "en la variable destino.", 0dh, 0ah, 24h


.code

;================================== INDICE DE FUNCIONES ================================================

public Caja_lectura_ASCII	;l¡nea 69
							;RECIBE DOS PAR METROS EN EL STACK; PRIMERO EL OFFSET DE LA VARIABLE DESTINO, 
							;Y SEGUNDO LA MODALIDAD DE ESCRITURA (0: indefinida, termina con 'ENTER';
							;>0: m ximo definido, seg£n la cantidad ingresada; o termina con 'ENTER')

public Caja_lectura_entero 	;l¡nea 147
							;NO RECIBE PAR METROS; PROCESA EL INGRESO (finaliza con ENTER) 
							;Y LO DEVUELVE EN dx COMO UN ENTERO DE 16 BITS
							;Controla el ingreso de n£meros

public Imprime_entero		;l¡nea 243
							;RECIBE UN ENTERO DE DOS BYTES COMO PAR METRO EN EL STACK Y LO IMPRIME EN PANTALLA

public Validar_caracter		;l¡nea 297
							;RECIBE DOS PAR METROS EN EL STACK; PRIMERO EL CARACTER A EVALUAR, 
							;SEGUNDO LA CONDICI¢N ESPERADA
							;(expresada con un entero: 1 = num‚rico, 2 = alfab‚tico, 3 = alfanum‚rico)
							;DEVUELVE EN dl 1 SI EL CARACTER ES V LIDO, O 0 EN CASO CONTRARIO

public regToASCII			;l¡nea 352
							;RECIBE DOS PAR METROS EN EL STACK; PRIMERO EL ENTERO DE DOS BYTES 
							;A CONVERTIR, Y SEGUNDO EL OFFSET DE LA VARIABLE DESTINO
							;(controla autom ticamente si el entero pasado es suficientemente peque¤o para
							;poder ser almacenado en la variable destino; esta variable debe contener caracteres
							;num‚ricos en las posiciones reservadas para recibir el entero; por ejemplo, 
							;se puede rellenar con ceros. Si el entero es muy alto o el offset recibido 
							;no contiene un caracter num‚rico, insulta y sale de la funci¢n sin devolver nada)

public ASCIIToReg			;l¡nea 457
							;RECIBE COMO PAR METRO EN EL STACK EL OFFSET DE LA VARIABLE FUENTE 
							;Y DEVUELVE EL ENTERO DE DOS BYTES EN dx
							;(calcula autom ticamente la cantidad de d¡gitos que contiene la variable fuente
							;el n£mero contenido en ‚sta no puede ser superior a 65535
							;si el offset recibido como par metro no contiene un n£mero, insulta y
							;devuelve 0 en dx)

public Limpiar_pantalla		;l¡nea 553
							;FUNCI¢N DE OTRO AUTOR; BORRA LA PANTALLA


;========================== C¢DIGO DE LAS FUNCIONES =================================================

Caja_lectura_ASCII proc
	push bp
	mov bp, sp ;PONE EL bp EN LA BASE DEL CUIDADO DEL ENTORNO (para que quede siempre a 4 bytes del £ltimo par metro)
	push ax ;RESGUARDA LOS REGISTROS QUE VA A ALTERAR
	push bx
	push cx
	push dx
	pushf ;GUARDA LOS FLAGS (por las moscas)

	mov dx, ss:[bp + 4] ;ALMACENA EN dx LA MODALIDAD
	mov bx, ss:[bp + 6] ;ALMACENA EN bx EL OFFSET PASADO COMO PAR METRO

	mov cx, 0 ;INICIALIZA cx PARA USARLO DESPU‚S COMO CONTADOR

	mov ah, 1 ;SERVICIO DE LECTURA DE CARACTER DE LA INT 21h

	cmp dx, 0 ;EVAL£A LA MODALIDAD
	je lectura_indefinida

lectura_definida: ;SI LA MODALIDAD ES DEFINIDA, HAY QUE EVALUAR SI EL CONTADOR ALCANZ¢ AL PAR METRO
	cmp cx, dx
	je terminar_cajaASCII

lectura_indefinida:
	int 21h 
	cmp al, 0dh ;SI SE INGRES¢ 'ENTER', TERMINA
	je terminar_cajaASCII

	cmp al, 08h ;SI SE INGRES¢ 'BACKSPACE', BORRA EL CARACTER ANTERIOR
	je borrar_caracter

	mov byte ptr[bx], al ;SI NO, ALMACENA EL CARACTER INGRESADO
	inc bx ;INCREMENTA EL ¡NDICE Y EL CONTADOR
	inc cx

continuar_lectura: 
	cmp dx, 0 ;SIEMPRE EVAL£A LA MODALIDAD DE SALIDA
	je lectura_indefinida

	jmp lectura_definida

borrar_caracter:
	push dx ;PRESERVA LA MODALIDAD Y EL SERVICIO DE LECTURA
	push ax

	mov ah, 2 ;SERVICIO DE ESCRITURA
	mov dl, 20h ;PISA EL CARACTER ANTERIOR CON UN ESPACIO
	int 21h

	cmp bx, ss:[bp + 6]
	je no_retrocede

	mov dl, 08h ;RETROCEDE EL CURSOR
	int 21h

	dec bx ;DECREMENTA EL ¡NDICE

	mov byte ptr[bx], 0dh ;ANULA EL INGRESO ANTERIOR

no_retrocede:
	pop ax
	pop dx

	jmp continuar_lectura

terminar_cajaASCII:
	popf ;RESTABLEZCE EL ENTORNO PREVIO
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4 ;BORRA EL PAR METRO Y VUELVE

Caja_lectura_ASCII endp

;=========================================================================================

Caja_lectura_entero proc
	push ax ;RESGUARDA LOS REGISTROS QUE VA A ALTERAR
	push bx
	push cx
	push si
	pushf ;GUARDA LOS FLAGS

	xor si, si ;INICIALIZA EL REGISTRO DONDE GUARDA EL ENTERO ACUMULADO
	mov bx, 10 ;USAR  bx PARA SHIFTEAR LOS D¡GITOS INGRESADOS (en decimal)

lectura:
	mov ah, 1 ;PIDE UN CARACTER
	int 21h

	cmp al, 0dh ;SI ES 'ENTER', FINALIZA
	je terminar_cajaEntero

	cmp al, 08h
	je borra_digito2

	xor ah, ah
	push ax ;VALIDA SI ES NUM‚RICO
	push 1
	call Validar_caracter

	cmp dl, 1 ;SI ES V LIDO, LO MANDA AL ACUMULADOR
	je acumular

	mov ah, 2 ;SI NO ES V LIDO, LO PISA
	mov dl, 08h ;CARACTER BACKSPACE
	int 21h

	mov ah, 2
	mov dl, 20h
	int 21h

	mov ah, 2
	mov dl, 08h
	int 21h
	jmp lectura ;VUELVE A LEER

borra_digito:
	mov ah, 2
	mov dl, 08h
	int 21h

borra_digito2:
	mov ah, 2
	mov dl, 20h
	int 21h

	mov ax, si ;DIVIDE POR 10 EL ACUMULADO
	xor dx, dx
	div bx
	mov si, ax
	cmp dx, 0
	jne seguir_borrado
	cmp si, 0
	je lectura

seguir_borrado:
	mov ah, 2
	mov dl, 08h
	int 21h

	jmp lectura

acumular:
	sub al, 30h ;CONVIERTE A ENTERO
	mov cl, al
	mov ax, si ;MULTIPLICA POR 10 EL ACUMULADO
	xor dx, dx
	mul bx

	add al, cl ;SUMA EL £LTIMO D¡GITO OBTENIDO
	mov si, ax

	cmp si, 999
	ja borra_digito

	jmp lectura

terminar_cajaEntero:
	mov dx, si ;DEVUELVE EL ACUMULADO EN dx

	popf ;RESTABLECE EL ENTORNO PREVIO
	pop si
	pop cx
	pop bx
	pop ax
	ret ;VUELVE

Caja_lectura_entero endp

;==========================================================================================

Imprime_entero proc 
	push bp
	mov bp, sp ;PONE EL bp EN LA BASE DEL CUIDADO DEL ENTORNO (para que quede siempre a 4 bytes del par metro)
	push ax ;RESGUARDA LOS REGISTROS QUE VOY A ALTERAR
	push cx
	push dx
	pushf ;GUARDA LOS FLAGS (por las moscas)

	mov ax, ss:[bp + 4] ;ALMACENA EN ax EL DATO PASADO COMO PAR METRO EN LA PRIMERA POSICI¢N DEL STACK
	xor dx, dx ;REINICIALIZA dx PORQUE AFECTA LA DIVISI¢N DE ax

	mov cx, 10000 ;DIVISOR

imprimir_descomposicion:
	div cx ;DIVIDE SIEMPRE POR EL PESO DEL D¡GITO, PARA CONVERTIRLO EN UNIDADES
	push dx ;GUARDA EL RESTO

	add al, 30h ;CONVIERTE A ASCII

	mov ah, 2 ;IMPRIME EL CARACTER
	mov dl, al
	int 21h

	xor dx, dx ;REINICIALIZA dx PORQUE INTERVIENE EN LA DIVISI¢N DE ax

	mov ax, cx ;REDUCE EL DIVISOR PARA LA DESCOMPOSICI¢N
	mov cx, 10
	div cx
	mov cx, ax ;GUARDA EL NUEVO DIVISOR EN cx

	pop ax ;RECUPERA EL RESTO DEL ENTERO DIVIDIDO

	cmp cx, 1 ;SI cx = 1, S¢LO FALTA GUARDAR EL £LTIMO RESTO
	je concluir_impresion_entero

	jmp imprimir_descomposicion

concluir_impresion_entero:
	add al, 30h
	mov ah, 2 ;IMPRIME EL £LTIMO CARACTER
	mov dl, al
	int 21h

	popf ;RESTABLECE EL ENTORNO PREVIO
	pop dx
	pop cx
	pop ax
	pop bp
	ret 2 ;BORRA EL PAR METRO Y VUELVE

Imprime_entero endp

;==============================================================================================

Validar_caracter proc
	push bp
	mov bp, sp
	push ax
	pushf

	mov al, ss:[bp + 6] ;GUARDA EN al EL CARACTER A EVALUAR
	mov ah, ss:[bp + 4] ;REGISTRA EN ah LA CONDICI¢N SOLICITADA

	cmp al, 30h ;COMPARA CON '0'
	jae verificar_nro
	jmp invalido ;SI ES MENOR, NO ES LETRA NI N£MERO = INV LIDO

verificar_nro:
	cmp al, 39h ;COMPARA CON '9'
	ja verificar_letra
	cmp ah, 2 ;SI SE COMPRUEBA UN N£MERO, EVAL£A CU L ERA LA CONDICI¢N SOLICITADA
	je invalido ;SI LA CONDICI¢N ERA 'ALFAB‚TICO', EL N£MERO SE INVALIDA
	mov dl, 1 ;SI NO, SE VALIDA
	jmp terminar_validacion

verificar_letra:
	cmp al, 41h ;COMPARA CON 'A'
	jb invalido ;SI ES MENOR, NO ES UNA LETRA (LOS N£MEROS YA EST N DESCARTADOS)
	cmp al, 5ah ;SI NO, COMPARO CON 'Z'
	ja verificar_minuscula
	cmp ah, 1 ;SI ES MENOR, ES UNA LETRA, Y EVAL£A LA CONDICI¢N SOLICITADA
	je invalido ;SI LA CONDICI¢N ERA 'NUM‚RICO', LA LETRA SE INVALIDA
	mov dl, 1 ;SI NO, SE VALIDA
	jmp terminar_validacion

verificar_minuscula:
	cmp al, 61h ;COMPARO CON 'a'
	jb invalido ;SI ES MENOR, NO ES UNA LETRA
	cmp al, 7ah ;COMPARO CON 'z'
	ja invalido ;SI ES MAYOR, NO ES UNA LETRA (N£MEROS YA DESCARTADOS)
	cmp ah, 1 ;EN CUALQUIER OTRA OCASI¢N, ES UNA LETRA; POR TANTO, EVAL£A LA CONDICI¢N SOLICITADA
	je invalido ;SI LA CONDICI¢N ERA 'NUM‚RICO', QUEDA INVALIDADO
	mov dl, 1 ;SI NO, SE VALIDA
	jmp terminar_validacion

invalido:
	mov dl, 0
	jmp terminar_validacion

terminar_validacion:
	popf
	pop ax
	pop bp

	ret 4 
Validar_caracter endp

;======================================================================================================

regToASCII proc 
	push bp
	mov bp, sp ;PONE EL bp EN LA BASE DEL CUIDADO DEL ENTORNO (para que quede siempre a 4 bytes del par metro)
	push ax ;RESGUARDA LOS REGISTROS QUE VA A ALTERAR
	push bx
	push cx
	push dx
	pushf ;GUARDA LOS FLAGS (por las moscas)

	mov bx, ss:[bp + 4] ;TOMA EN bx EL OFFSET DE LA VARIABLE DESTINO PARA CONTAR LA CANTIDAD DE D¡GITOS Y 
						;PODER CALCULAR EL DIVISOR NECESARIO PARA LA DESCOMPOSICI¢N

	mov cx, [bx] ;CHEQUEA SI EN EL OFFSET RECIBIDO HAY UN N£MERO
	push cx
	mov cx, 1
	push cx
	call Validar_caracter

	cmp dl, 1 ;SI LO HAY, VA A CALCULAR EL DIVISOR
	je calcular_divisor

	lea dx, variable_no_numerica ;SI NO, INSULTA Y SALE DE LA FUNCI¢N, DEVOLVIENDO 0 EN dx
	mov ah, 9
	int 21h

	jmp salir_regToASCII

calcular_divisor:
	mov ax, 1 ;EN ax ACUMULAR  EL VALOR INICIAL DEL DIVISOR
	xor cx, cx
cuenta_digitos1:
	inc bx	;YA SABE QUE EL PRIMER D¡GITO ES V LIDO, Y ax TIENE EL PESO INICIAL DE 1. DE MODO QUE
			;COMIENZA VALIDANDO Y AUMENTANDO EL DIVISOR DESDE EL SEGUNDO D¡GITO
	mov cl, [bx] ;COPIO EL VALOR ASCII DEL D¡GITO PARA VALIDARLO
	push cx
	mov cx, 1
	push cx

	call Validar_caracter ;VALIDA SI EL CAR CTER ACTUAL ES N£MERO

	cmp dl, 0 ;SI NO, SALE PORQUE TERMIN¢ DE RECORRER LA VARIABLE NUM‚RICA
	je salir_contar_digitos1

	mov dx, 10 ;SI EL CARACTER ACTUAL ES N£MERO, AUMENTA EL DIVISOR
	mul dx
	jmp cuenta_digitos1 ;SIGUE RECORRIENDO LA VARIABLE NUM‚RICA

salir_contar_digitos1:
	mov cx, ax ;GUARDA EN cx EL DIVISOR PARA LA DESCOMPOSICI¢N

	mov ax, ss:[bp + 6] ;VALIDA SI EL ENTERO PASADO POR PAR METRO ES LOS SUFICIENTEMENTE CHICO 
						;COMO PARA PODER SER ESCRITO EN LA VARIABLE DESTINO
	div cx 
	cmp ax, 9
	jle empezar_descomposicion ;SI LA DIVISI¢N DEL ENTERO POR EL DIVISOR OBTENIDO ES NUEVE O MENOR,
								;ENTRA EN LA VARIABLE DESTINO

	mov ah, 9
	lea dx, entero_demasiado_alto
	int 21h
	jmp salir_regToASCII

empezar_descomposicion:
	mov bx, ss:[bp + 4] ;VUELVE A PONER A bx EN EL OFFSET DE LA VARIABLE DESTINO PARA RECORRERLA
	xor dx, dx ;REINICIALIZA dx PORQUE AFECTA LA DIVISI¢N DE ax
	mov ax, ss:[bp + 6] ;ALMACENA EN ax EL DATO PASADO COMO PAR METRO EN LA PRIMERA POSICI¢N DEL STACK

descomposicion:
	div cx ;DIVIDE SIEMPRE POR EL PESO DEL D¡GITO, PARA CONVERTIRLO EN UNIDADES

	add al, 30h ;CONVIERTE A ASCII

	mov byte ptr[bx], al ;ALMACENA EL ASCII OBTENIDO
	inc bx ;INCREMENTA LA POSICI¢N DE MEMORIA DONDE GUARDAR
	push dx ;GUARDA EL RESTO

	xor dx, dx ;REINICIALIZA dx PORQUE INTERVIENE EN LA DIVISI¢N DE ax
	mov ax, cx ;REDUCE EL DIVISOR PARA LA DESCOMPOSICI¢N
	mov cx, 10
	div cx
	mov cx, ax ;GUARDA EL NUEVO DIVISOR EN cx
	pop ax ;RECUPERA EL RESTO DEL ENTERO DIVIDIDO

	cmp cx, 1 ;SI cx = 1, S¢LO FALTA GUARDAR EL £LTIMO RESTO
	je concluir_regToASCII

	jmp descomposicion

concluir_regToASCII:
	add al, 30h
	mov byte ptr[bx], al
	
salir_regToASCII:
	popf ;RESTABLECE EL ENTORNO PREVIO
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp

	ret 4 ;BORRA LOS PAR METROS Y VUELVE
regToASCII endp

;==========================================================================================

ASCIIToReg proc
	push bp
	mov bp, sp ;PONE EL bp EN LA BASE DEL CUIDADO DEL ENTORNO (para que quede siempre a 4 bytes del par metro)
	push ax ;RESGUARDA LOS REGISTROS QUE VA A ALTERAR (salvo cx, porque lo voy a romper para devolver el entero)
	push bx
	push cx
	pushf ;GUARDA LOS FLAGS (por las moscas)

	mov bx, ss:[bp + 4] ;TOMA EN bx EL OFFSET DE LA VARIABLE ORIGEN PARA CONTAR LA CANTIDAD DE D¡GITOS Y 
						;PODER CALCULAR EL MULTIPLICADOR NECESARIO PARA LA COMPOSICI¢N
	
	mov cx, [bx] ;CHEQUEA SI EN EL OFFSET RECIBIDO HAY UN N£MERO
	push cx
	mov cx, 1
	push cx
	call Validar_caracter

	cmp dl, 1 ;SI LO HAY, VOY A CALCULAR EL MULTIPLICADOR
	je calcular_multiplicador

	lea dx, variable_no_numerica ;SI NO, INSULTA Y SALE DE LA FUNCI¢N, DEVOLVIENDO 0 EN dx
	mov ah, 9
	int 21h

	xor dx, dx
	jmp salir_ASCIIToReg

calcular_multiplicador:
	mov ax, 1 ;EN ax ACUMULAR  EL VALOR INICIAL DEL MULTIPLICADOR
	xor cx, cx
cuenta_digitos:
	inc bx	;YA SABE QUE EL PRIMER D¡GITO ES V LIDO, Y ax TIENE EL PESO INICIAL DE 1. DE MODO QUE
			;COMIENZA VALIDANDO Y AUMENTANDO EL MULTIPLICADOR DESDE EL SEGUNDO D¡GITO
	mov cl, [bx] ;COPIA EL VALOR ASCII DEL D¡GITO PARA VALIDARLO
	push cx
	mov cx, 1
	push cx

	call Validar_caracter ;VALIDA SI EL CAR CTER ACTUAL ES N£MERO

	cmp dl, 0 ;SI NO, SALE PORQUE TERMIN¢ DE RECORRER LA VARIABLE NUM‚RICA
	je salir_contar_digitos

	mov dx, 10 ;SI EL CARACTER ACTUAL ES N£MERO, AUMENTA EL MULTIPLICADOR
	mul dx
	jmp cuenta_digitos ;SIGUE RECORRIENDO LA VARIABLE NUM‚RICA

salir_contar_digitos:
	mov cx, ax ;GUARDA EN cx EL MULTIPLICADOR PARA LA COMPOSICI¢N

	xor dx, dx ;INICIALIZA EL ACUMULADOR
	mov bx, ss:[bp + 4] ;VUELVE A PONER A bx EN EL OFFSET DE LA VARIABLE FUENTE PARA RECORRERLA
	push dx ;COMO dx INTERVIENE EN LAS MULTIPLICACIONES Y LAS DIVISIONES, HAY QUE RESGUARDARLO EN EL STACK

composicion:
	mov al, [bx] ;ALMACENA EN al EL PRIMER D¡GITO, PARA PODER OPERARLO
	sub al, 30h ;CONVIERTE A ENTERO
	xor ah, ah ;XOREA ah PARA NO ALTERAR LA MULTIPLICACI¢N
	mul cx ;MULTIPLICA

	pop dx ;RECUPERA EL ACUMULADO
	add dx, ax ;ACUMULA EL RESULTADO EN dx
	push dx ;GUARDA EL ACUMULADO

	xor dx, dx
	mov ax, cx ;REDUCE EL MULTIPLICADOR PARA LA COMPOSICI¢N DEL PR¢XIMO N£MERO
	mov cx, 10
	div cx
	mov cx, ax ;GUARDA EL NUEVO DIVISOR EN cx

	inc bx ;DESPLAZA EL PUNTERO A LA VARIABLE DESTINO

	cmp cx, 1 ;SI cx = 1, S¢LO FALTA GUARDAR EL £LTIMO D¡GITO
	je concluir_ASCIIToReg

	jmp composicion

concluir_ASCIIToReg:
	mov al, [bx]
	sub al, 30h

	pop dx ;RECUPERA EL ACUMULADO
	add dl, al
	
salir_ASCIIToReg:
	popf ;RESTABLECE EL ENTORNO PREVIO
	pop cx
	pop bx
	pop ax
	pop bp

	ret 2;BORRA EL PAR METRO Y VUELVE
ASCIIToReg endp

;=========================================================================================================

Limpiar_pantalla proc
	push ax
	push es
	push cx
	push di
	mov ax,3
	int 10h
	mov ax,0b800h
	mov es,ax
	mov cx,1000
	mov ax,7
	mov di,ax
	cld
	rep stosw
	pop di
	pop cx
	pop es
	pop ax
	ret 
Limpiar_pantalla endp

end