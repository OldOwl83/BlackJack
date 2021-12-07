;======================================================================================================


;== LIBRER¡A PARA EL REGISTRO Y MANIPULACI¢N DEL NOMBRE DEL USUARIO, Y GESTI¢N DEL SAL¢N DE LA FAMA ===


;======================================================================================================

.8086
.model small
.stack 100h

.data

usuario db 34 dup(0dh) ;REGISTRO DEL NOMBRE DE USUARIO

;=========== MANEJO DEL ARCHIVO DE LOS MIEMBROS DEL SAL¢N DE LA FAMA ============================

archivo_fama db "c:\tasm\bj\fama.txt", 24h  ;ESTE ARCHIVO SIEMPRE DEBE FINALIZAR CON UN CARACTER NULO COMO
											;INDICADOR DE EOF; SI SE BORRA SU CONTENIDO, EL CARACTER NULO
											;DEBE CONSERVARSE COMO SU £NICO BYTE.
handler_fama dw 0

buffer_lectura_escritura db 54 dup(125), 0, 126
buffer_auxiliar db 54 dup(125), 0, 126

posicion_registrada db 0

;CARTELES DE ERROR
err_apertura db "Archivo inexistente o error de apertura.", 0dh, 0ah, 24h
err_lectura db "Error de lectura de archivo.", 0dh, 0ah, 24h
err_puntero db "Error en la ubicaci¢n del puntero al archivo fama.txt.", 0dh, 0ah, 24h
err_escritura db "Error en la escritura del archivo fama.txt.", 0dh, 0ah, 24h
err_cierre db "Error en la clausura del archivo fama.txt.", 0dh, 0ah, 24h

;======================= CARTELES PARA EL SAL¢N DE LA FAMA =====================================

cartel_silencio	db 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h
				db 05h, "                                                       ", 05h
				db 04h, "                                                       ", 04h
				db 06h, "                                                       ", 06h
				db 03h, "          Por no haber ingresado ning£n nombre         ", 03h
				db 05h, "                                                       ", 05h
				db 04h, "                 en la l¡nea de comandos,              ", 04h
				db 06h, "                                                       ", 06h
				db 03h, "       te pierdes en el silencio de la historia.       ", 03h
				db 05h, "                                                       ", 05h
				db 04h, "                                                       ", 04h
				db 06h, "                                                       ", 06h
				db 03h, "        Y no olvides presionar cualquier tecla...      ", 03h
				db 05h, "                  ...antes de irte                     ", 05h
				db 04h, "                                                       ", 04h
				db 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h

cartel_victoria	db 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h
				db 05h, "                                                       ", 05h
				db 04h, "                                                       ", 04h
				db 06h, "                                                       ", 06h
				db 03h, "                    ­Felicitaciones!                   ", 03h
				db 05h, "                                                       ", 05h
				db 04h, "                Has sumado una victoria                ", 04h
				db 06h, "                                                       ", 06h
				db 03h, "       en tu carrera hacia el sal¢n de la fama.        ", 03h
				db 05h, "                                                       ", 05h
				db 04h, "                                                       ", 04h
				db 06h, "                                                       ", 06h
				db 03h, "        Y no olvides presionar cualquier tecla...      ", 03h
				db 05h, "                  ...antes de irte                     ", 05h
				db 04h, "                                                       ", 04h
				db 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h


cartel_fama db 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h
			db 05h, "                                                       ", 05h
			db 04h, "                    SAL¢N DE LA FAMA                   ", 04h
			db 06h, "                                                       ", 06h
			db 03h, "                                                       ", 03h
			db 05h, "            JUGADOR                        VICTORIAS   ", 05h
			db 04h, "                                                       ", 04h
			db 06h, "   1-                                                  ", 06h
			db 03h, "   2-                                                  ", 03h
			db 05h, "   3-                                                  ", 05h
			db 04h, "   4-                                                  ", 04h
			db 06h, "   5-                                                  ", 06h
			db 03h, "   6-                                                  ", 03h
			db 05h, "                                                       ", 05h
			db 04h, "                                                       ", 04h
			db 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h

.code

;=========================== FUNCIONES EXTERNAS ==================================================

extrn Imprimir_cartel:proc
extrn regToASCII:proc
extrn Caja_lectura_ASCII:proc

;============================= INDICE DE FUNCIONES ====================================================

public Ingresar_usuario		;l¡nea 126
							;NO RECIBE PAR METROS. GESTIONA EL INGRESO DE HASTA 32 CARACTERES Y LO REGISTRA
							;EN LA VARIABLE 'usuario'; ADEM S, GRABA ESE USUARIO EN EL CARTEL DE VICTORIA PARA
							;EL SAL¢N DE LA FAMA.

public Retornar_usuario 	;l¡nea 141
							;NO RECIBE PAR METROS; DEVUELVE EN cl LA LONGITUD DEL NOMBRE DE USUARIO Y EN si EL 
							;OFFSET DE LA VARIABLE DONDE EST  ALMACENADO EL MISMO

public Grabar_usuario		;l¡nea 169
							;RECIBE COMO PAR METRO EN EL STACK EL OFFSET DEL CARTEL DONDE GRABAR EL NOMBRE
							;DEL USUARIO; UNA VEZ GRABADO, EL NOMBRE DE USUARIO APARECER  CADA VEZ QUE SE 
							;IMPRIMA EL CARTEL PASADO A LA FUNCI¢N.

public Modificar_salon_fama	 	;l¡nea 226
								;NO RECIBE PAR METROS; TOMA EL USUARIO REGISTRADO Y GESTIONA SU
								;TRIUNFO EN EL SAL¢N DE LA FAMA; SI NO ESTABA EN EL MISMO, LO INCORPORA AL FINAL 
								;Y LE ASIGNA UNA VICTORIA; SI ESTABA, LE SUMA UNA VICTORIA Y LO REPOSICIONA EN
								;LA TABLA DESCENDENTE DE GANADORES HIST¢RICOS (todo dentro del archivo 'fama.txt')

public Imprimir_salon		;l¡nea 557
							;IMPRIME EL SAL¢N DE LA FAMA. NO RECIBE PAR METROS. LEE EL ARCHIVO 'fama.txt'
							;Y DESPLIEGA LOS REGISTROS EN EL CARTEL FAMA.

;=========================== C¢DIGO DE FUNCIONES ==================================================

Ingresar_usuario proc

	push offset usuario
	push 32

	call Caja_lectura_ASCII

	push offset cartel_victoria
	call Grabar_usuario

	ret
Ingresar_usuario endp

;========================================================================================================

Retornar_usuario proc
	push es
	pushf

	lea si, usuario

	xor cl, cl

recorrer_usuario:
	cmp byte ptr [si], 0dh
	je salir_retornar_usuario

	inc si
	inc cl

	jmp recorrer_usuario

salir_retornar_usuario:
	lea si, usuario

	popf
	pop es

	ret
Retornar_usuario endp

;========================================================================================================

Grabar_usuario proc
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push si
	pushf

	xor ax, ax ;CONTADOR PARA CALCULAR LA LONGITUD DEL USUARIO, Y PODER CENTRARLO
	lea bx, usuario ;APUNTA A bx A LA VARIABLE QUE CONTIENE EL usuario

tamanio_usuario:
	cmp byte ptr [bx], 0dh ;SI SE ENCUENTRA UN 'ENTER', TERMIN¢ DE RECORRER EL USUARIO
	je salir_tamanio_usuario

	inc bx ;SI NO, SIGUE CONTANDO
	inc ax
	jmp tamanio_usuario

salir_tamanio_usuario:
	mov cl, 2 ;DIVIDE LA LONGITUD DEL USUARIO A LA MITAD, PARA PODER CENTRARLO
	div cl
	xor ah, ah

	mov bx, 142 ;CALCULA LA POSICI¢N DONDE COMIENZA LA GRABACI¢N
	sub bx, ax

	add bx, ss:[bp + 4] ;SUMA EL OFFSET PASADO A LA FUNCI¢N PARA PODER RECORRER LA ZONA A GRABAR

	lea si, usuario ;¡NDICE PARA RECORRER EL USUARIO EN LA VARIABLE DE REGISTRO
imprimir_usuario:
	cmp byte ptr [si], 0dh ;SI SE ENCUENTRA UN 'ENTER', TERMIN¢ DE RECORRER EL USUARIO
	je salir_impresion_usuario

	mov dl, [si] ;GRABA CADA CARACTER EN LA POSICI¢N CORRESPONDIENTE
	mov [bx], dl

	inc bx ;INCREMENTA LOS ¡NDICES
	inc si
	jmp imprimir_usuario

salir_impresion_usuario:
	popf
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp

	ret 2
Grabar_usuario endp

;=========================================================================================================

Modificar_salon_fama proc
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	pushf

	lea bx, usuario

;GUARDA EL USUARIO EN EL BUFFER
	mov si, 0 ;¡NDICE DE ESCRITURA DEL BUFFER
recorro_usuario:
	cmp byte ptr [bx], 0dh ;SI SE ENCUENTRA UN 'ENTER', TERMIN¢ DE RECORRER EL USUARIO
	je salir_recorro_usuario

	mov al, byte ptr [bx] ;SI NO, GUARDA EL CARACTER Y SIGUE CONTANDO
	mov buffer_lectura_escritura[si], al
	inc bx 
	inc si
	jmp recorro_usuario

silencio_historia0:
	jmp silencio_historia

error_apertura0:
	jmp error_apertura

salir_recorro_usuario:
	cmp si, 0 ;SI si ES IGUAL A 0, NO SE INGRES¢ USUARIO, Y POR TANTO ENV¡O AL SILENCIO DE LA HISTORIA
	je silencio_historia0

;SI NO, PROCEDO A GESTIONAR SU VICTORIA EN EL ARCHIVO "fama.txt"

;APERTURA DEL ARCHIVO "fama.txt"
	lea dx, archivo_fama ;RECIBE EL OFFSET DEL NOMBRE DEL ARCHIVO
	mov ah, 3dh ;SERVICIO DE APERTURA DE ARCHIVO
	mov al, 10000010b ;MODO DE LECTURA/ESCRITURA (nibble menos significativo)
					;S¢LO CONCEDE PERMISO AL PROGRAMA ACTUAL (nibble m s significativo)
	int 21h 
	jc error_apertura0 ;SI SE PRENDE EL CARRY, HUBO ERROR EN LA APERTURA
	
	mov word ptr handler_fama, ax ;SI NO, GUARDA EL HANDLER DEL ARCHIVO

;RECORRE EL ARCHIVO, PARA CHEQUEAR SI YA EXISTE EL USUARIO REGISTRADO EN EL BUFFER
volver_a_comparar:
	lea si, buffer_lectura_escritura ;¡NDICE DEL BUFFER PRINCIPAL (usuario registrado en el extra segment)
	lea di, buffer_auxiliar ;¡NDICE DEL BUFFER AUXILIAR (usuario le¡do del archivo)

	inc posicion_registrada ;CONTADOR PARA LA POSICI¢N QUE OCUPA EL USUARIO REGISTRADO
							;(si finalmente se lo encuentra)

;COMIENZA LA LECTURA DEL ARCHIVO fama.txt
	mov bx, handler_fama
seguir_comparando:
	mov ah, 3fh ;SERVICIO DE LECTURA DE ARCHIVO
	mov cx, 1 ;CANTIDAD DE CARACTERES A GRABAR
	mov dx, di ;OFFSET DEL GRABADO (guardo en el buffer auxiliar)
	int 21h
	jc error_lectura0

	cmp byte ptr [di], 00h ;SI ALCANZ¢ EL EOF, ES PORQUE NO ENCONTR¢ COINCIDENCIAS
							;POR TANTO, VA A INGRESAR AL USUARIO ACTUAL AL SAL¢N DE LA FAMA
	je ingreso_salon0

	mov cl, [si] ;SI NO, COMPARA EL CARACTER RECIEN GRABADO CON SU EQUIVALENTE EN EL BUFFER PRINCIPAL
					;(o sea, chequea si el usuario registrado y el usuario le¡do en cada posici¢n del archivo son iguales)
	cmp [di], cl
	jne no_coinciden ;SI HAY ALG£N CARACTER EN EL QUE NO COINCIDEN, SON DISTINTOS, Y VA A CORRER EL PUNTERO 
						;HACIA LA SIGUIENTE POSICI¢N EN EL ARCHIVO

	cmp byte ptr [di], 125 ;SI ALCANZ¢ EL PRIMER '}' COINCIDIENDO EN AMBOS BUFFERS, ENCONTR¢ UNA 
							;COINCIDENCIA PLENA
	je incremento_victorias

	inc di ;SI AUN NO LLEGU¢ AL '}', PERO CONTIN£AN LAS COINCIDENCIAS, SIGUE COMPARANDO
	inc si
	jmp seguir_comparando

ingreso_salon0:
	jmp ingreso_salon

error_lectura0:
	jmp error_lectura

no_coinciden: ;SI NO HUBO COINCIDENCIA, LLEVA EL PUNTERO HACIA LA SIGUIENTE POSICI¢N
				;LA CUAL EST  LUEGO DEL PR¢XIMO '~'
	inc di

	mov ah, 3fh
	;mov bx, handler_fama
	mov cx, 1
	mov dx, di
	int 21h
	jc error_lectura0

	cmp byte ptr [di], 126 ;CUANDO ENCONTR¢ EL SIGUIENTE ~, REINICIO LA COMPARACI¢N
	je volver_a_comparar

	jmp no_coinciden

guardar_posic_superior0:
	jmp guardar_posic_superior

incremento_victorias:
	inc di ;SIGUE COPIANDO LA POSICI¢N A INCREMENTAR DE MANERA COMPLETA EN EL BUFFER AUXILIAR

	mov ah, 3fh
	;mov bx, handler_fama
	mov cx, 1
	mov dx, di
	int 21h
	jc error_lectura0

	cmp byte ptr [di], 126 ;MIENTRAS NO ENCUENTRE '~', AVANZA POR EL ARCHIVO HASTA COMPLETAR LA POSICI¢N
	jne incremento_victorias

	inc byte ptr [di - 1] ;INCREMENTA EL ENTERO EN EL BUFFER AUXILIAR

	cmp posicion_registrada, 1
	je guardar_posic_superior0

desplazamientos_posiciones:
	mov ah, 42h ;RECOLOCACI¢N DEL PUNTERO AL ARCHIVO
	mov al, 01h ;CON ESTE VALOR, SE TOMA COMO REFERENCIA LA POSICI¢N ACTUAL DEL PUNTERO
	mov bx, handler_fama
	mov cx, 0ffffh ;cx Y dx (mitad menos significativa) CONTIENEN EL DESPLAZAMIENTO 
				;RESPECTO DE LA UBICACI¢N ESTABLECIDA EN al
	mov dx, 0ffc6h ;INICIALIZA EL DESPLAZAMIENTO EN -58, PARA QUE UBIQUE AL ENTERO DE LA POSICI¢N ANTERIOR
	int 21h
	jc error_ubicacion_puntero0

	mov ah, 3fh ;LECTURA DEL ENTERO ANTERIOR
	;mov bx, handler_fama
	mov cx, 1
	lea dx, buffer_lectura_escritura ;EN EL BUFFER PRINCIPAL TRABAJAR  CON LAS POSICIONES SUPERIORES A COMPARAR
	int 21h
	jc error_lectura1

	mov cl, [di - 1]
	cmp cl, buffer_lectura_escritura
	jbe guardar_posicion

	mov ah, 42h ;RECOLOCACI¢N DEL PUNTERO AL ARCHIVO
	mov al, 01h ;CON ESTE VALOR, SE TOMA COMO REFERENCIA LA POSICI¢N ACTUAL DEL PUNTERO
	mov bx, handler_fama
	mov cx, 0ffffh ;cx Y dx (mitad menos significativa) CONTIENEN EL DESPLAZAMIENTO 
				;RESPECTO DE LA UBICACI¢N ESTABLECIDA EN al
	mov dx, 0ffc9h ;INICIALIZA EL DESPLAZAMIENTO EN -55, PARA QUE TOME A LA POSICI¢N ANTERIOR DESDE
					;EL PRINCIPIO, Y PODER COPIARLA COMPLETA EN LA POSICI¢N SIGUIENTE
	int 21h
	jc error_ubicacion_puntero0

	mov ah, 3fh ;LEE LA POSICI¢N A DESPLAZAR COMPLETA
	;mov bx, handler_fama
	mov cx, 56
	lea dx, buffer_lectura_escritura
	int 21h
	jc error_lectura1

	mov ah, 40h ;ESCRIBE LA POSICI¢N A DESPLAZAR COMPLETA EN LA SIGUIENTE POSICI¢N
	mov cx, 56 ;CANTIDAD DE CARACTERES A GRABAR DESDE EL BUFFER
	lea dx, buffer_lectura_escritura
	int 21h
	jc error_escritura0

	mov ah, 42h ;RECOLOCACI¢N DEL PUNTERO AL ARCHIVO PARA QUE, AL VOLVER, PUEDA SUBIR DOS POSICIONES
	mov al, 01h ;CON ESTE VALOR, SE TOMA COMO REFERENCIA LA POSICI¢N ACTUAL DEL PUNTERO
	mov bx, handler_fama
	mov cx, 0ffffh ;cx Y dx (mitad menos significativa) CONTIENEN EL DESPLAZAMIENTO 
				;RESPECTO DE LA UBICACI¢N ESTABLECIDA EN al
	mov dx, 0ffc8h ;INICIALIZA EL DESPLAZAMIENTO EN -56, PARA QUE TOME A LA POSICI¢N ANTERIOR DESDE
					;EL PRINCIPIO, Y PODER SALTAR A LA OTRA
	int 21h
	jc error_ubicacion_puntero0

	dec posicion_registrada
	cmp posicion_registrada, 1
	je guardar_posic_superior

	jmp desplazamientos_posiciones

error_lectura1:
	jmp error_lectura

error_escritura0:
	jmp error_escritura

error_ubicacion_puntero0:
	jmp error_ubicacion_puntero

guardar_posicion:
	mov ah, 42h ;RECOLOCACI¢N DEL PUNTERO AL ARCHIVO
	mov al, 01h ;CON ESTE VALOR, SE TOMA COMO REFERENCIA LA POSICI¢N ACTUAL DEL PUNTERO
	mov bx, handler_fama
	mov cx, 0 ;cx Y dx (mitad menos significativa) CONTIENEN EL DESPLAZAMIENTO 
				;RESPECTO DE LA UBICACI¢N ESTABLECIDA EN al
	mov dx, 1 ;AVANZA UNO PARA SITUARSE AL COMIENZO DE LA SIGUIENTE POSICI¢N RESPECTO DE AQUELLA
				;QUE NO PUDO SUPERAR
	int 21h
	jc error_ubicacion_puntero

	jmp guardar_registro

guardar_posic_superior:
	mov ah, 42h ;RECOLOCACI¢N DEL PUNTERO AL ARCHIVO
	mov al, 00h ;CON ESTE VALOR, SE COLOCA EL PUNTERO EN LA POSICI¢N INICIAL
	mov bx, handler_fama
	mov cx, 0 ;cx Y dx (mitad menos significativa) CONTIENEN EL DESPLAZAMIENTO 
				;RESPECTO DE LA UBICACI¢N ESTABLECIDA EN al
	mov dx, 0 
	int 21h
	jc error_ubicacion_puntero

guardar_registro:
	mov ah, 40h ;ESCRIBE LA POSICI¢N A DESPLAZAR COMPLETA EN LA SIGUIENTE POSICI¢N
	mov cx, 56 ;CANTIDAD DE CARACTERES A GRABAR DESDE EL BUFFER
	lea dx, buffer_auxiliar
	int 21h
	jc error_escritura

	jmp salir_salon_fama

ingreso_salon:
;UBICA EL PUNTERO AL ARCHIVO AL FINAL, PARA AGREGAR UN NUEVO USUARIO (todo usuario comienza en la
;posici¢n inferior, porque s¢lo tiene una victoria)
	mov ah, 42h
	mov al, 02h ;CON ESTE VALOR, SE ENV¡A EL PUNTERO AL FINAL DEL ARCHIVO
	mov bx, handler_fama
	mov cx, 0ffffh ;cx Y dx (mitad menos significativa) CONTIENEN EL DESPLAZAMIENTO 
				;RESPECTO DE LA UBICACI¢N ESTABLECIDA EN al
	mov dx, 0ffffh ;INICIALIZA EL DESPLAZAMIENTO EN -1, PARA QUE BORRE EL EOF ANTERIOR
	int 21h
	jc error_ubicacion_puntero

	mov ah, 40h ;ESCRITURA DEL ARCHIVO fama.txt
	mov cx, 54 ;CANTIDAD DE CARACTERES A GRABAR DESDE EL BUFFER
	lea dx, buffer_lectura_escritura
	int 21h
	jc error_escritura

	;mov bx, 1 ;COPIA EN EL BUFFER EL N£MERO INICIAL DE VICTORIAS (1) Y EL CARACTER DE CIERRE DE L¡NEA (~)
	mov buffer_lectura_escritura, 1
	mov buffer_lectura_escritura[1], 126
	mov buffer_lectura_escritura[2], 00h ;CARACTER '\0' LO USA COMO EOF

	mov ah, 40h
	mov bx, handler_fama
	mov cx, 3
	lea dx, buffer_lectura_escritura
	int 21h
	jc error_escritura

	jmp salir_salon_fama

error_escritura:
	lea dx, err_escritura
	jmp cerrar_error

error_ubicacion_puntero:
	lea dx, err_puntero ;IMPRIME EL CARTEL DE ERROR
	jmp cerrar_error

error_apertura:
	lea dx, err_apertura ;IMPRIME EL CARTEL DE ERROR
	jmp cerrar_error

error_lectura:
	lea dx, err_lectura ;IMPRIME EL CARTEL DE ERROR
	jmp cerrar_error

error_cierre:
	lea dx, err_cierre ;IMPRIME EL CARTEL DE ERROR
	jmp cerrar_error

cerrar_error:
	mov cx, ax ;PRESERVA EL C¢DIGO DEL ERROR
	mov ah, 9
	int 21h
	mov ah, 2
	mov dl, ch ;IMPRIME EL C¢DIGO DEL ERROR
	int 21h
	mov dl, cl
	int 21h

	mov ah, 1
	int 21h

	jmp salir_salon2

silencio_historia:
	push offset cartel_silencio
	push 1
	
	call Imprimir_cartel

	jmp salir_salon2

salir_salon_fama:
	mov ah, 3eh ;CIERRA EL ARCHIVO
	mov bx, handler_fama
	int 21h

	push offset cartel_victoria
	push 1

	call Imprimir_cartel

	mov posicion_registrada, 0 ;REINICIALIZA ESTE CONTADOR POR SI VUELVO A INGRESAR EN ESTA FUNCI¢N
	mov handler_fama, 0 ;RESETEA EL HANDLER, PORQUE SI NO HACE L¡O CUANDO SE VUELVE A LLAMAR A LA FUNCI¢N
	jc error_cierre

salir_salon2:

	popf
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp

	ret
Modificar_salon_fama endp

;===========================================================================================================

Imprimir_salon proc
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	pushf

	push offset cartel_fama
	push 0

	call Imprimir_cartel

;APERTURA DEL ARCHIVO 'fama.txt'
	lea dx, archivo_fama ;RECIBE EL OFFSET DEL NOMBRE DEL ARCHIVO
	mov ah, 3dh ;SERVICIO DE APERTURA DE ARCHIVO
	mov al, 10000000b ;MODO DE S¢LO LECTURA (nibble menos significativo)
					;S¢LO CONCEDE PERMISO AL PROGRAMA ACTUAL (nibble m s significativo)
	int 21h 
	jc error_apertura_imp0 ;SI SE PRENDE EL CARRY, HUBO ERROR EN LA APERTURA
	
	mov word ptr handler_fama, ax ;SI NO, GUARDA EL HANDLER DEL ARCHIVO

;LEE Y COPIA LOS PRIMEROS SEIS REGISTROS DE 'fama.txt'
	;lea si, buffer_lectura_escritura

leer_registro_siguiente:
	mov al, posicion_registrada ;GUARDA EN dh (fila de la lista) LA POSICI¢N ACTUAL
	add al, 11
	mov dh, al

	mov ah, 2 ;ASIGNA POSICI¢N AL CURSOR
	xor bh, bh
	mov dl, 20 ;COLUMNA INICIAL
	int 10h

	mov si, 20 ;USA si PARA DESPLAZAR EL CURSOR DE SALIDA POR PANTALLA

seguir_leyendo:
	cmp posicion_registrada, 6
	jae salir_imprimir_fama0

	mov bx, handler_fama
	mov ah, 3fh ;SERVICIO DE LECTURA DE ARCHIVO
	mov cx, 1 ;CANTIDAD DE CARACTERES A LEER
	lea dx, buffer_lectura_escritura ;OFFSET DEL BUFFER (guardo en el buffer principal)
	int 21h
	jc error_lectura_imp0

	cmp byte ptr buffer_lectura_escritura[0], 00h ;SI ALCANZ¢ EL EOF, TERMIN¢ DE LEER
	je salir_imprimir_fama0

	cmp byte ptr buffer_lectura_escritura[0], 125
	je avanzar_hacia_entero

	mov ah, 09h ;IMPRIME LOS CARACTERES DETECTADOS EN EL ARCHIVO
	mov al, buffer_lectura_escritura[0]
	mov bh, 0
	mov bl, 01101111b 
	;mov cx, 1
	int 10h

;AVANZA EL CURSOR A LA SIGUIENTE POSICI¢N
	inc si
	mov dx, si
	mov al, posicion_registrada ;GUARDA EN dh (fila de la lista) LA POSICI¢N ACTUAL
	add al, 11
	mov dh, al
	mov ah, 2 ;REASIGNA POSICI¢N AL CURSOR
	xor bh, bh
	
	int 10h

	jmp seguir_leyendo

error_apertura_imp0:
	jmp error_apertura_imp

salir_imprimir_fama0:
	jmp salir_imprimir_fama

error_lectura_imp0:
	jmp error_lectura_imp

avanzar_hacia_entero:
	mov ah, 3fh ;LECTURA
	;mov bx, handler_fama
	;mov cx, 1
	lea dx, buffer_lectura_escritura
	int 21h
	jc error_lectura_imp0

	cmp byte ptr buffer_lectura_escritura[0], 125
	jne imprimir_entero

	jmp avanzar_hacia_entero

imprimir_entero:
	mov buffer_auxiliar[0], '0' ;PREPARA EL BUFFER QUE RECIBE EL ENTERO EN ASCIIS
	mov buffer_auxiliar[1], '0'
	mov buffer_auxiliar[2], '0'

	xor dx, dx
	mov dl, buffer_lectura_escritura[0] ;GRABA EL ASCII EN EL BUFFER
	push dx
	push offset buffer_auxiliar

	call regToASCII

	mov di, 62
	mov si, 0
	mov cx, 0
imprimir_ASCII:
	mov dx, di

	mov al, posicion_registrada ;GUARDA EN dh (fila de la lista) LA POSICI¢N ACTUAL
	add al, 11
	mov dh, al

	mov ah, 2 ;REASIGNA POSICI¢N AL CURSOR
	xor bh, bh
	int 10h

	cmp buffer_auxiliar[si], 30h
	je saltar_ASCII

volver_imprimir_ASCII:
	mov ah, 09h ;IMPRIME LOS CARACTERES DETECTADOS EN EL ARCHIVO
	mov al, buffer_auxiliar[si]
	mov bh, 0
	mov bl, 01101111b 
	mov cx, 1
	int 10h

	jmp seguir_imprimir_ASCII
saltar_ASCII:
	cmp cx, 1
	je volver_imprimir_ASCII

seguir_imprimir_ASCII:
	inc di
	inc si

	cmp si, 3
	jae salir_imprimir_ASCII

	jmp imprimir_ASCII

salir_imprimir_ASCII:
	mov ah, 42h ;RECOLOCACI¢N DEL PUNTERO AL ARCHIVO
	mov al, 01h ;CON ESTE VALOR, SE TOMA COMO REFERENCIA LA POSICI¢N ACTUAL DEL PUNTERO
	mov bx, handler_fama
	mov cx, 0 ;cx Y dx (mitad menos significativa) CONTIENEN EL DESPLAZAMIENTO 
				;RESPECTO DE LA UBICACI¢N ESTABLECIDA EN al
	mov dx, 1 ;AVANZA UNO PARA SITUARSE AL COMIENZO DE LA SIGUIENTE POSICI¢N A IMPRIMIR
	int 21h
	jc error_ubicacion_puntero_imp

	inc posicion_registrada
	jmp leer_registro_siguiente

error_ubicacion_puntero_imp:
	lea dx, err_puntero ;IMPRIME EL CARTEL DE ERROR
	jmp cerrar_error_imp

error_apertura_imp:
	lea dx, err_apertura ;IMPRIME EL CARTEL DE ERROR
	jmp cerrar_error_imp

error_lectura_imp:
	lea dx, err_lectura ;IMPRIME EL CARTEL DE ERROR
	jmp cerrar_error_imp

error_cierre_imp:
	lea dx, err_cierre ;IMPRIME EL CARTEL DE ERROR
	jmp cerrar_error_imp

cerrar_error_imp:
	mov cx, ax ;PRESERVA EL C¢DIGO DEL ERROR
	mov ah, 9
	int 21h
	mov ah, 2
	mov dl, ch ;IMPRIME EL C¢DIGO DEL ERROR
	int 21h
	mov dl, cl
	int 21h

salir_imprimir_fama:
	mov ah, 3eh ;CIERRA EL ARCHIVO
	mov bx, handler_fama
	int 21h

	mov posicion_registrada, 0 ;REINICIALIZA ESTE CONTADOR POR SI VUELVE A INGRESAR EN ESTA FUNCI¢N
	mov handler_fama, 0 ;RESETEA EL HANDLER, PORQUE SI NO HACE L¡O CUANDO VUELVE A LLAMAR A LA FUNCI¢N
	jc error_cierre_imp

	popf
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax

	ret
Imprimir_salon endp

end