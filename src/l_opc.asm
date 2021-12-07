;======================================================================================================


;================================ FUNCIONES N£CLEO - PRESENTACI¢N Y DESARROLLO DEL JUEGO ==============


;======================================================================================================

.8086
.model small
.stack 100h

.data

;======================== LETREROS DEL CUADRO DE DI LOGO ==============================================

bienvenida db "­Bienvenido, forastero! "
solicitud_apuesta db "¨Cu nto deseas apostar? "

mal_ingreso db "¨Te tiemblan los dedos? ­Ingresa una apuesta v lida!"

apuesta_rechazada db "No te alcanza la bolsa. Prueba con una apuesta m s humilde: "

empezar_reparto db "¨Est s preparado/a para el reparto de cartas?", 0dh, 0ah, 9
				db "Pulsa cualquier tecla, o ESC para salir."

opciones_mano1 db "¨C¢mo seguimos? (1) Pedir carta; (2) Plantarse; (3) Doblar apuesta;", 0dh, 0ah, 9
				db "(ESC para salir)"
opciones_mano2 db "¨C¢mo seguimos? (1) Pedir carta; (2) Plantarse;", 0dh, 0ah, 9 
				db "(ESC para salir)"

mano_pasada db "­No debiste pedir esa carta!", 0dh, 0ah, 9 
			db "Pulsa cualquier tecla para seguir perdiendo, o ret¡rate con ESC."

obtuvo_bj db "­BlackJack! "
destapar_carta db "­Ahora veamos qu‚ ten¡a escondido el crupier!", 0dh, 0ah, 9
				db "Presiona cualquier tecla, o ESC para salir."

sigue_crupier db "Parece que no llega al 17 y debe servirse otra carta.", 0dh, 0ah, 9
			db "Presiona cualquier tecla para continuar, o ESC para salir."

gana_mano db "­Vaya suerte! Recibe tu premio.", 0dh, 0ah, 9
			db "Presiona cualquier tecla para continuar, o ESC para salir."

empate_bj db "­Qu‚ mala suerte, es un empate! Al menos recuperas tu apuesta.", 0dh, 0ah, 9
				db "Presiona cualquier tecla para continuar, o ESC para salir."

obtuvo_bj_crupier db "­BlackJack para la casa! "
pierde_mano db "Espero que sigas as¡... perdiendo. ­Int‚ntalo de nuevo!", 9
				db "Presiona cualquier tecla para continuar, o ESC para salir."

apuesta_doblada db "­Qu‚ valiente! Ah¡ tienes el pozo duplicado.", 0dh, 0ah, 9
				db "Presiona cualquier tecla para ver tu carta, o ESC para salir."

mano_blanda_no_pierde db "No pienso perder con una mano blanda. ­Pedir‚ otra carta para la casa!", 0dh, 0ah, 9
						db "(ESC para salir)"

;================================= VARIABLES DE SONIDO ==============================================

ruidito_ascendente dw 4060, 2710, 24h
ruidito_descendente dw 2710, 4060, 24h

ritmo_ruidito dw 2, 2

;======================== CONTADOR DE MANOS GANADAS DE MANERA CONSECUTIVA ============================

triunfos_al_hilo db 0

;============================ CARTELER¡A DE LA PRESENTACI¢N =========================================

encabezado 	db 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h
			db 05h, "                                                       ", 05h
			db 04h, "    BIENVENIDO/A A NUESTRA C‚LEBRE CASA DE APUESTAS    ", 04h
			db 06h, "                                                       ", 06h
			db 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h


cartel_presentacion 	db "²²²²    ²²       ²²²²    ²²²²   ²²  ²²        ²²   ²²²²    ²²²²   ²²  ²²"
						db "²²²²²   ²²      ²²²²²²  ²²²²²²  ²²  ²²        ²²  ²²²²²²  ²²²²²²  ²²  ²²"
						db "²²  ²±  ²²      ²²  ²±  ²²  ²±  ²² ²±         ²²  ²²  ²±  ²²  ²±  ²² ²² "
						db "²²  ±±  ²²      ²²  ±±  ²²      ²²²±          ²²  ²²  ±±  ²²      ²²²±  "
						db "²² ±±   ²²      ²²  ±±  ²²      ²²±           ²²  ²²  ±±  ²²      ²²±   "
						db "²±±±    ²±      ²±±±±±  ²±      ²±±±          ²±  ²±±±±±  ²±      ²±±±  "
						db "±±±±±   ±±      ±±±±±°  ±±      ±±±±          ±±  ±±±±±°  ±±      ±±±±  "
						db "±±  °°  ±±      ±±  °°  ±±      ±± ±°         °°  ±±  °°  ±±      ±± ±° "
						db "±±  °°  ±±      ±±  °°  ±±  °°  ±±  °°    ±±  °°  ±±  °°  ±±  °°  ±±  °°"
						db "±±°°°   ±±°°°°  ±±  °°  ±±°°°°  ±±  °°    ±±°°°°  ±±  °°  ±±°°°°  ±±  °°"
						db "±°°°    ±°°°°°  ±°  °°   °°°°   ±°  °°     °°°°   ±°  °°   °°°°   ±°  °°"

;============================ M£SICA DE LA PRESENTACI¢N =============================================

notas_presentacion 	dw 8122, 24h, 5420, 24h, 1916, 24h, 2030, 24h, 2279, 24h, 1, 24h, 2710, 24h, 1, 24h, 7235, 24h, 1, 24h
					dw 4829, 24h, 3042, 24h, 2710, 24h, 2279, 24h, 2710, 24h, 1, 24h, 8122, 24h, 5420, 24h, 1916, 24h
					dw 2030, 24h, 2279, 24h, 1, 24h, 2710, 24h, 1, 24h, 7235, 24h, 1, 24h, 2710, 24h, 1, 24h, 4829, 24h, 1, 24h
					dw 2710, 24h, 1, 24h, 8122, 24h, 5420, 24h, 1916, 24h, 2030, 24h, 2279, 24h, 1, 24h, 2710, 24h, 1, 24h
					dw 7235, 24h, 1, 24h, 4829, 24h, 3042, 24h, 2710, 24h, 2279, 24h, 2710, 24h, 1, 24h, 8122, 24h, 1, 24h
					dw 1916, 24h, 2030, 24h, 7235, 24h, 2710, 24h, 3042, 24h, 2710, 24h, 10841, 24h 

ritmo_presentacion 	dw    3,         3,         3,         3,         5,      1,         5,      1,         5,      1
					dw    3,         3,         3,         3,         3,      3,         3,         3,         3
					dw    3,         5,      1,         5,      1,         5,      1,         5,      1,         5,      1
					dw    5,      1,         3,         3,         3,         3,         4,      2,         4,      2
					dw    4,      2,         3,         3,         3,         3,         3,      3,         5,      1
					dw    3,         3,         3,         3,         3,         3,         10

.code

;============================= FUNCIONES EXTERNAS ===================================================

extrn Barajar_mazo:proc
extrn Imprimir_tapete:proc
extrn Imprimir_credito:proc
extrn Servir_carta:proc
extrn Cuadro_dialogo:proc
extrn Caja_lectura_entero:proc
extrn Imprime_entero:proc ;s¢lo para pruebas
extrn Recibir_apuesta:proc
extrn Borrar_cuadro_dialogo:proc
extrn Imprimir_carta_tapada:proc
extrn Evaluar_mano:proc
extrn Reiniciar_mazo:proc
extrn Resetear_pozo:proc
extrn Evaluar_credito:proc
extrn Pagar_ganancias:proc
extrn Evaluacion_doblar_apuesta:proc
extrn Cajita_musical:proc
extrn Restablecer_credito:proc
extrn Detencion_espera_tecla:proc

;========================== INDICE DE FUNCIONES ========================================================

public Desarrollo_juego 	;l¡nea 148
							;Desarrolla un juego completo de BJ dando al usuario las opciones para
							;interactuar con el crupier.
							;El juego termina cuando se da una de las siguientes condiciones: 
							;(1) El usuario se queda sin cr‚dito, lo que equivale a una derrota.
							;(2) El usuario alcanza los 400 C de cr‚dito, lo que equivale a un triunfo.
							;(3) El usuario gana 5 manos seguidas y la casa lo expulsa, lo que equivale
							;a un triunfo. (La funci¢n devuelve en dx 0 para el primer caso, 1 para el
							;segundo y 2 para el tercero; en caso de que el usuario salga mediante ESC,
							;devuelve 3 en dx).

public Presentacion			;l¡nea 752
							;Ejecuta la presentaci¢n del programa

;=========================== C¢DIGO DE LAS FUNCIONES ===================================================

Desarrollo_juego proc
	push bp
	push ax
	push bx
	push cx
	push si
	push di
	pushf

	mov ah, 0 ;ESTABLECE MODO VIDEO
	mov al, 10h ;MODO GR FICO 640x350, 16 COLORES
	int 10h

;PREPARACI¢N DEL JUEGO
	call Imprimir_tapete

	call Borrar_cuadro_dialogo

	call Imprimir_credito

	call Barajar_mazo

	push offset bienvenida ;SALUDA Y SOLICITA APUESTA
	mov dx, 48
	push dx
	call Cuadro_dialogo
	jmp pedir_apuesta

nueva_mano:
	call Reiniciar_mazo

	call Borrar_cuadro_dialogo

	call Imprimir_tapete

	call Imprimir_credito

	call Barajar_mazo

	push offset solicitud_apuesta ;SOLICITA APUESTA
	mov dx, 24
	push dx
	call Cuadro_dialogo

	jmp pedir_apuesta

sin_ingreso:
	call Borrar_cuadro_dialogo

	push offset mal_ingreso ;SOLICITA APUESTA
	mov dx, 52
	push dx
	call Cuadro_dialogo
;RECEPCI¢N DE LA PRIMERA APUESTA
pedir_apuesta:
	call Caja_lectura_entero

	push offset ruidito_ascendente
	push offset ritmo_ruidito

	call Cajita_musical

	cmp dx, 0 ;SI NO HUBO INGRESO, VUELVE A PEDIR APUESTA
	je sin_ingreso

	push dx

	call Recibir_apuesta

	call Borrar_cuadro_dialogo

	cmp dx, 1
	je comienzo_reparto

	push offset apuesta_rechazada ;CARTEL DE RECHAZO DE LA APUESTA
	mov dx, 60
	push dx
	call Cuadro_dialogo

	jmp pedir_apuesta

;COMIENZA REPARTO
comienzo_reparto:
	push offset empezar_reparto ;PARA PEDIR LAS PRIMERAS DOS CARTAS DEL USUARIO
	mov dx, 88
	push dx
	call Cuadro_dialogo

	call Detencion_espera_tecla ;DETENCI¢N

	cmp al, 01bh ;COMPARA CON 'ESC' PARA SALIR
	je retiro_juego0

	push offset ruidito_ascendente
	push offset ritmo_ruidito

	call Cajita_musical

	call Borrar_cuadro_dialogo

;SACA LAS PRIMERAS DOS CARTAS PARA EL USUARIO, Y UNA VERDADERA Y OTRA FALSA PARA EL CRUPIER
	mov dx, 1 ;PIDE CARTA PARA EL USUARIO
	push dx
	call Servir_carta

	mov dx, 1 ;PIDE CARTA PARA EL USUARIO
	push dx
	call Servir_carta

	mov dx, 0 ;PIDE CARTA PARA EL CRUPIER
	push dx
	call Servir_carta

	call Imprimir_carta_tapada ;IMPRIME LA FALSA CARTA TAPADA PARA EL CRUPIER

	mov dx, 1 ;PIDE EVALUAR LA MANO DEL USUARIO
	push dx

	call Evaluar_mano

	cmp dx, 40
	je blackjack0

	jmp opc_mano1

salir_juego0:
	jmp salir_juego

retiro_juego0:
	jmp retiro_juego

blackjack0:
	jmp blackjack

;OPCIONES PARA LAS DOS PRIMERAS CARTAS
opc_mano1:
	push offset opciones_mano1 ;OPCIONES: PEDIR, PLANTARSE O DOBLAR
	mov dx, 86
	push dx
	call Cuadro_dialogo

	call Detencion_espera_tecla ;DETENCI¢N

	cmp al, 01bh ;COMPARA CON 'ESC' PARA SALIR
	je retiro_juego0

	push offset ruidito_ascendente
	push offset ritmo_ruidito

	call Cajita_musical

	call Borrar_cuadro_dialogo

	cmp al, '1'
	je sacar_carta_usuario
	cmp al, '2'
	je plantarse0
	cmp al, '3'
	je doblar_apuesta0

	jmp opc_mano1

doblar_apuesta0:
	jmp doblar_apuesta

plantarse0:
	jmp plantarse

;SACA CARTAS ADICIONALES
sacar_carta_usuario:
	mov dx, 1 ;PIDE CARTA PARA EL USUARIO
	push dx
	call Servir_carta

	mov dx, 1 ;PIDE EVALUAR LA MANO DEL USUARIO
	push dx

	call Evaluar_mano

	cmp dx, 40
	je blackjack0

	cmp dx, 0
	je se_paso

;OPCIONES LUEGO DE PEDIR CARTAS ADICIONALES
opc_mano2:
	push offset opciones_mano2 ;OPCIONES: PEDIR O PLANTARSE
	mov dx, 66
	push dx
	call Cuadro_dialogo

	call Detencion_espera_tecla ;DETENCI¢N

	cmp al, 01bh ;COMPARA CON 'ESC' PARA SALIR
	je retiro_juego1

	push offset ruidito_descendente
	push offset ritmo_ruidito

	call Cajita_musical

	call Borrar_cuadro_dialogo

	cmp al, '1'
	je sacar_carta_usuario0
	cmp al, '2'
	je plantarse0

	jmp opc_mano2

sacar_carta_usuario0:
	jmp sacar_carta_usuario

se_paso:
	call Resetear_pozo
	call Imprimir_credito

	mov triunfos_al_hilo, 0 ;REINICIA EL CONTADOR DE MANOS GANADAS AL HILO

	push offset mano_pasada ;SE BURLA DE QUE SE PAS¢
	mov dx, 95
	push dx
	call Cuadro_dialogo

	call Detencion_espera_tecla ;DETENCI¢N

	cmp al, 01bh ;COMPARA CON 'ESC' PARA SALIR
	je retiro_juego1

	push offset ruidito_ascendente
	push offset ritmo_ruidito

	call Cajita_musical

	call Evaluar_credito ;REVISA SI QUEDA SALDO EN EL CR‚DITO DEL USUARIO
	cmp dx, 0 ;SI NO, TRAMITA LA DERROTA
	je derrota0

	call Borrar_cuadro_dialogo
	jmp nueva_mano

derrota0:
	jmp derrota
salir_juego1:
	jmp salir_juego

retiro_juego1:
	jmp retiro_juego

blackjack:
	push offset obtuvo_bj ;DA VUELTA LA CARTA OCULTA DEL CRUPIER
	mov dx, 102
	push dx
	call Cuadro_dialogo

	call Detencion_espera_tecla ;DETENCI¢N

	cmp al, 01bh ;COMPARA CON 'ESC' PARA SALIR
	je retiro_juego1

	push offset ruidito_ascendente
	push offset ritmo_ruidito

	call Cajita_musical

	call Borrar_cuadro_dialogo

	mov dx, 0 ;PIDE CARTA PARA EL CRUPIER
	push dx
	call Servir_carta

	mov dx, 0 ;PIDE EVALUAR LA MANO DEL CRUPIER
	push dx

	call Evaluar_mano

	cmp dx, 40
	je empate0

	push offset gana_mano ;CELEBRA EL TRIUNFO
	mov dx, 92
	push dx
	call Cuadro_dialogo

	call Detencion_espera_tecla ;DETENCI¢N

	cmp al, 01bh ;COMPARA CON 'ESC' PARA SALIR
	je retiro_juego1

	push offset ruidito_ascendente
	push offset ritmo_ruidito

	call Cajita_musical

	call Borrar_cuadro_dialogo

	mov dx, 2 ;PIDE PAGAR GANANCIAS POR 2:3
	push dx
	call Pagar_ganancias

	call Evaluar_credito ;EVAL£A SI ALCANZ¢ LOS 400 C, LO CUAL ES UNA CONDICI¢N DE SALIDA
	cmp dx, 400
	jae alcanza_400c0

	inc triunfos_al_hilo ;AUMENTA EL CONTADOR DE MANOS GANADAS AL HILO
	cmp triunfos_al_hilo, 5 ;SI ALCANZ¢ LAS 5 MANOS AL HILO, SE CUMPLE UNA CONDICI¢N DE SALIDA
	je cinco_al_hilo0

	jmp nueva_mano

empate0:
	jmp empate

alcanza_400c0:
	jmp alcanza_400c

cinco_al_hilo0:
	jmp cinco_al_hilo

plantarse:
	push offset destapar_carta ;DA VUELTA LA CARTA OCULTA DEL CRUPIER
	mov dx, 91
	jmp desocultar_carta

salir_juego2:
	jmp salir_juego

retiro_juego2:
	jmp retiro_juego

pide_por_mano_blanda:
	push offset mano_blanda_no_pierde
	mov dx, 89
	jmp desocultar_carta

pide_carta_crupier:
	push offset sigue_crupier ;OTRA CARTA PARA EL CRUPIER
	mov dx, 114

desocultar_carta:
	push dx
	call Cuadro_dialogo

	call Detencion_espera_tecla ;DETENCI¢N

	cmp al, 01bh ;COMPARA CON 'ESC' PARA SALIR
	je retiro_juego2

	push offset ruidito_descendente
	push offset ritmo_ruidito

	call Cajita_musical

	call Borrar_cuadro_dialogo

	mov dx, 0 ;PIDE CARTA PARA EL CRUPIER
	push dx
	call Servir_carta

	mov dx, 0 ;PIDE EVALUAR LA MANO DEL CRUPIER
	push dx

	call Evaluar_mano

	cmp dx, 0
	je triunfo_usuario0

	cmp dx, 40
	je blackjack_crupier

	cmp dx, 17
	jl pide_carta_crupier

	mov bx, dx ;SI SUPER¢ LOS 17, HAY QUE COMPARAR CON LA MANO DEL USUARIO
	push cx ;GUARDA LA CONDICI¢N DE LA MANO DEL CRUPIER, PARA QUE NO PIERDA CON MANO BLANDA

	mov dx, 1 ;EVAL£A LA MANO DEL USUARIO, PARA COMPARAR CON LA DEL CRUPIER
	push dx
	call Evaluar_mano

	pop cx ;RECUPERA LA CONDICI¢N DE LA MANO DEL CRUPIER

	cmp dx, bx ;SI GANA EL USUARIO, FALTA CORROBORAR SI LA MANO DEL CRUPIER ERA DURA O BLANDA
	jg corroborar_mano_crupier

	cmp dx, bx
	je empate

	push offset pierde_mano ;SE BURLA DE LA P‚RDIDA
	mov dx, 114
	jmp mano_perdida

corroborar_mano_crupier:
	cmp cx, 0 ;SI LA MANO DEL CRUPIER ERA BLANDA, SIGUE SACANDO CARTAS
	jne pide_por_mano_blanda0
triunfo_usuario0:
	jmp triunfo_usuario ;SI NO, TRAMITA EL TRIUNFO DEL USUARIO

pide_por_mano_blanda0:
	jmp pide_por_mano_blanda

blackjack_crupier:
	push offset obtuvo_bj_crupier ;SE BURLA DEL BJ DE LA CASA
	mov dx, 140

mano_perdida:
	push dx
	call Cuadro_dialogo

	call Resetear_pozo
	call Imprimir_credito

	call Detencion_espera_tecla ;DETENCI¢N

	cmp al, 01bh ;COMPARA CON 'ESC' PARA SALIR
	je retiro_juego3

	push offset ruidito_descendente
	push offset ritmo_ruidito

	call Cajita_musical

	call Borrar_cuadro_dialogo

	call Evaluar_credito

	cmp dx, 0
	je derrota1

	mov triunfos_al_hilo, 0 ;REINICIALIZA EL CONTADOR DE MANOS GANADAS AL HILO

	jmp nueva_mano

derrota1:
	jmp derrota

salir_juego3:
	jmp salir_juego

retiro_juego3:
	jmp retiro_juego

empate:
	push offset empate_bj ;SE CONDUELE
	mov dx, 123
	push dx
	call Cuadro_dialogo

	call Detencion_espera_tecla ;DETENCI¢N

	cmp al, 01bh ;COMPARA CON 'ESC' PARA SALIR
	je retiro_juego3

	push offset ruidito_descendente
	push offset ritmo_ruidito

	call Cajita_musical

	call Borrar_cuadro_dialogo

	mov dx, 0 ;PIDE LA DEVOLUCI¢N DEL POZO
	push dx
	call Pagar_ganancias

	mov triunfos_al_hilo, 0 ;REINICIALIZA EL CONTADOR DE MANOS GANADAS AL HILO

	jmp nueva_mano

triunfo_usuario:
	push offset gana_mano ;CELEBRA EL TRIUNFO
	mov dx, 92
	push dx
	call Cuadro_dialogo

	call Detencion_espera_tecla ;DETENCI¢N

	cmp al, 01bh ;COMPARA CON 'ESC' PARA SALIR
	je retiro_juego3

	push offset ruidito_ascendente
	push offset ritmo_ruidito

	call Cajita_musical

	call Borrar_cuadro_dialogo

	mov dx, 1 ;PIDE PAGAR GANANCIAS POR 1:1
	push dx
	call Pagar_ganancias

	call Evaluar_credito ;EVAL£A SI ALCANZ¢ LOS 400 C, LO CUAL ES UNA CONDICI¢N DE SALIDA
	cmp dx, 400
	jae alcanza_400c1

	inc triunfos_al_hilo ;AUMENTA EL CONTADOR DE MANOS GANADAS AL HILO
	cmp triunfos_al_hilo, 5 ;SI ALCANZ¢ LAS 5 MANOS AL HILO, SE CUMPLE UNA CONDICI¢N DE SALIDA
	je cinco_al_hilo1

	jmp nueva_mano

alcanza_400c1:
	jmp alcanza_400c

cinco_al_hilo1:
	jmp cinco_al_hilo

doblar_apuesta:
	call Evaluacion_doblar_apuesta

	cmp dx, 1
	je continuar_doblar_apuesta

	push offset apuesta_rechazada ;CARTEL DE RECHAZO DE LA APUESTA
	mov dx, 24
	push dx
	call Cuadro_dialogo

	call Detencion_espera_tecla ;DETENCI¢N

	cmp al, 01bh ;COMPARA CON 'ESC' PARA SALIR
	je retiro_juego

	push offset ruidito_ascendente
	push offset ritmo_ruidito

	call Cajita_musical

	call Borrar_cuadro_dialogo

	jmp opc_mano2

continuar_doblar_apuesta:
	push offset apuesta_doblada ;CELEBRA LA VALENT¡A
	mov dx, 108
	push dx
	call Cuadro_dialogo

	call Detencion_espera_tecla ;DETENCI¢N

	cmp al, 01bh ;COMPARA CON 'ESC' PARA SALIR
	je retiro_juego

	push offset ruidito_ascendente
	push offset ritmo_ruidito

	call Cajita_musical

	call Borrar_cuadro_dialogo

	mov dx, 1 ;PIDE CARTA PARA EL USUARIO
	push dx
	call Servir_carta

	mov dx, 1 ;PIDE EVALUAR LA MANO DEL USUARIO
	push dx

	call Evaluar_mano

	cmp dx, 0 ;SI PASA DE LOS 21, VA A CERRAR LA MANO
	je se_paso0

	jmp plantarse ;SI NO, SALTA A PLANTARSE, DONDE SE SIGUE DESARROLLANDO EL JUEGO

se_paso0:
	jmp se_paso

cinco_al_hilo:
	mov dx, 2
	jmp salir_juego

alcanza_400c:
	mov dx, 1
	jmp salir_juego

derrota:
	mov dx, 0
	jmp salir_juego

retiro_juego:
	mov dx, 3

salir_juego:
	call Restablecer_credito
	call Reiniciar_mazo

;RESTABLECE EL MODO TEXTO PARA VOLVER AL main
	mov ah,00 ;modo texto
	mov al,03 ;modo color
	int 10h

	popf
	pop di
	pop si
	pop cx
	pop bx
	pop ax
	pop bp

	ret
Desarrollo_juego endp

;==============================================================================================

Presentacion proc
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	pushf

	lea si, encabezado
	mov dh, 1 ;FILA INICIAL
	mov dl, 12 ;COLUMNA INICIAL
	mov cx, 1 ;CANTIDAD DE VECES QUE ESCRIBE EL CARACTER

imprime_encabezado:
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

	mov bl, 00001111b ;COLOR TEXTO
	jmp color_establecido

es_rojo:
	mov bl, 00000100b ;ROJO
	jmp color_establecido

es_negro:
	mov bl, 00001000b ;NEGRO
	
color_establecido:
	int 10h

	inc si ;DESPLAZA EL PUNTERO A LA VARIABLE DEL CARTEL A IMPRIMIR
	inc dl ;MUEVE LA COLUMNA DEL CURSOR
	cmp dl, 68 ;SI ALCANZA LA COLUMNA 68, DEBE BAJAR DE FILA
	ja bajar_fila_encabezado
	jmp imprime_encabezado

bajar_fila_encabezado:
	mov dl, 12 ;REINICIALIZA LA COLUMNA
	inc dh	;INCREMENTA LA FILA
	cmp dh, 5 ;SI ALCANZ¢ LA FILA 5, TERMINA LA IMPRESI¢N
	ja salir_impresion_encabezado
	jmp imprime_encabezado

salir_impresion_encabezado:
;IMPRESI¢N DEL BLACK JACK
	mov di, 0

imprime_cartel:
	lea si, cartel_presentacion
	xor bx, bx
	mov dh, 8 ;FILA INICIAL
	mov dl, 4 ;COLUMNA INICIAL

imprime_caracter:
	mov ax, si
	xor ah, ah
	xor cx, cx
	mov cl, 98
	sub cx, di
	div cl

	cmp ah, 0
	je rosa0
	cmp ah, 1
	je blanco0
	cmp ah, 2
	je blanco0
	cmp ah, 3
	je dorado0
	cmp ah, 4
	je blanco0
	cmp ah, 5
	je blanco0
	cmp ah, 6
	je rojo0
	cmp ah, 7
	je rosa0
	cmp ah, 8
	je blanco0
	cmp ah, 9
	je dorado0
	cmp ah, 10
	je blanco0
	cmp ah, 11
	je amarillo0
	cmp ah, 12
	je blanco0
	cmp ah, 13
	je blanco0
	cmp ah, 14
	je rojo0
	cmp ah, 15
	je blanco0
	cmp ah, 16
	je blanco0
	cmp ah, 17
	je rosa0
	cmp ah, 18
	je blanco0
	cmp ah, 19
	je blanco0
	cmp ah, 20
	je amarillo0
	jmp seguir_numeros

blanco0:
	jmp blanco

rosa0:
	jmp rosa

rojo0:
	jmp rojo

amarillo0:
	jmp amarillo

dorado0:
	jmp dorado

seguir_numeros:
	cmp ah, 21
	je dorado0
	cmp ah, 22
	je blanco0
	cmp ah, 23
	je blanco0
	cmp ah, 24
	je rojo0
	cmp ah, 25
	je amarillo0
	cmp ah, 26
	je blanco0
	cmp ah, 27
	je blanco0
	cmp ah, 28
	je dorado0
	cmp ah, 29
	je rosa0
	cmp ah, 30
	je amarillo0
	cmp ah, 31
	je blanco0
	cmp ah, 32
	je blanco0
	cmp ah, 33
	je rojo0
	cmp ah, 34
	je dorado0
	cmp ah, 35
	je blanco0
	cmp ah, 36
	je blanco0
	cmp ah, 37
	je rojo0
	cmp ah, 38
	je rosa0
	cmp ah, 39
	je blanco0
	cmp ah, 40
	je blanco0
	cmp ah, 41
	je rojo0
	cmp ah, 42
	je blanco0
	cmp ah, 43
	je blanco1
	cmp ah, 44
	je dorado1
	cmp ah, 45
	je blanco1
	cmp ah, 46
	je blanco1
	cmp ah, 47
	je blanco1
	cmp ah, 48
	je amarillo1
	cmp ah, 49
	je rojo1
	cmp ah, 50
	je blanco1
	cmp ah, 51
	je blanco1
	cmp ah, 52
	je dorado1
	cmp ah, 53
	je rosa1
	cmp ah, 54
	je blanco1
	cmp ah, 55
	je blanco1
	cmp ah, 56
	je amarillo1
	cmp ah, 57
	je blanco1
	cmp ah, 58
	je blanco1
	cmp ah, 59
	je rosa1
	jmp seguir_numeros2

blanco1:
	jmp blanco

rosa1:
	jmp rosa

rojo1:
	jmp rojo

amarillo1:
	jmp amarillo

dorado1:
	jmp dorado

seguir_numeros2:
	cmp ah, 60
	je rojo1
	cmp ah, 61
	je blanco1
	cmp ah, 62
	je blanco1
	cmp ah, 63
	je amarillo1
	cmp ah, 64
	je rojo1
	cmp ah, 65
	je amarillo1
	cmp ah, 66
	je blanco1
	cmp ah, 67
	je blanco1
	cmp ah, 68
	je rosa1
	cmp ah, 69
	je blanco1
	cmp ah, 70
	je blanco1
	cmp ah, 71
	je rosa1
	cmp ah, 72
	je dorado1
	cmp ah, 73
	je blanco1
	cmp ah, 74
	je blanco1
	cmp ah, 75
	je rojo1
	cmp ah, 76
	je amarillo1
	cmp ah, 77
	je blanco1
	cmp ah, 78
	je blanco1
	cmp ah, 79
	je rojo1
	cmp ah, 80
	je rosa1
	cmp ah, 81
	je blanco
	cmp ah, 82
	je blanco
	cmp ah, 83
	je dorado
	cmp ah, 84
	je blanco
	cmp ah, 85
	je blanco
	cmp ah, 86
	je rojo
	cmp ah, 87
	je rosa
	cmp ah, 88
	je blanco
	cmp ah, 89
	je blanco
	cmp ah, 90
	je dorado
	cmp ah, 91
	je amarillo
	cmp ah, 92
	je blanco
	cmp ah, 93
	je blanco
	cmp ah, 94
	je rojo
	cmp ah, 95
	je blanco
	cmp ah, 96
	je blanco
	cmp ah, 97
	je rosa
	cmp ah, 98
	je blanco
	cmp ah, 99
	je blanco
	cmp ah, 100
	je amarillo
	cmp ah, 101
	je dorado
	cmp ah, 102
	je blanco
	cmp ah, 103
	je blanco
	cmp ah, 104
	je rojo

blanco:
	mov bl, 00001111b
	jmp continuar_impresion

rosa:
	mov bl, 00001100b
	jmp continuar_impresion

rojo:
	mov bl, 00000100b
	jmp continuar_impresion

amarillo:
	mov bl, 00001110b
	jmp continuar_impresion

dorado:
	mov bl, 00000110b
	jmp continuar_impresion

continuar_impresion:
	mov ah, 2 ;ASIGNA POSICI¢N AL CURSOR
	mov bh, 0 ;NRO DE P GINA
	int 10h

	mov ah, 09h ;ESCRIBE EN LA POSICI¢N DEL CURSOR
	mov al, [si] ;CARACTER

	mov cx, 1 ;CANTIDAD DE VECES QUE ESCRIBE EL CARACTER
	int 10h

	inc si ;DESPLAZA EL PUNTERO A LA VARIABLE DEL CARTEL A IMPRIMIR
	inc dl ;MUEVE LA COLUMNA DEL CURSOR
	cmp dl, 75 ;SI ALCANZA LA COLUMNA 75, DEBE BAJAR DE FILA
	ja bajar_fila
	jmp imprime_caracter

bajar_fila:
	mov dl, 4 ;REINICIALIZA LA COLUMNA
	inc dh	;INCREMENTA LA FILA
	cmp dh, 18 ;FILA FINAL
	ja salir_impresion_caracter
	jmp imprime_caracter

salir_impresion_caracter:
;OCULTA EL CURSOR
	mov ah, 2 ;ASIGNA POSICI¢N AL CURSOR
	mov bh, 0 ;NRO DE P GINA
	mov dh, 25 ;FILA INICIAL
	mov dl, 80 ;COLUMNA INICIAL
	int 10h

;EJECUTA LA SIGUIENTE NOTA MUSICAL
	mov ax, di
	mov cl, 4
	mul cl

	lea bx, notas_presentacion
	add bx, ax

	push bx

	mov cl, 2
	div cl
	lea bx, ritmo_presentacion
	add bx, ax

	push bx

	call Cajita_musical

	inc di

	cmp di, 57
	je salir_impresion_cartel

	jmp imprime_cartel

salir_impresion_cartel:

	popf
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax

	ret
Presentacion endp

end