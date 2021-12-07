;======================================================================================================


;================================ ARCHIVO PRINCIPAL - FUNCI¢N MAIN ===================================


;======================================================================================================

.8086
.model small
.stack 100h

.data

;======================================= CARTELES ============================================================

cartel_menu db 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h
			db 05h, "                                                       ", 05h
			db 04h, "                    MENU de OPCIONES                   ", 04h
			db 06h, "                                                       ", 06h
			db 03h, "                                                       ", 03h
			db 05h, "               1- Pasar al sal¢n de juego              ", 05h
			db 04h, "                                                       ", 04h
			db 06h, "               2- Presentaci¢n del juego               ", 06h
			db 03h, "                                                       ", 03h
			db 05h, "                  3- Sal¢n de la fama                  ", 05h
			db 04h, "                                                       ", 04h
			db 06h, "              4- Acerca de este programa               ", 06h
			db 03h, "                                                       ", 03h
			db 05h, "                      5- Salir                         ", 05h
			db 04h, "                                                       ", 04h
			db 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h

cartel_derrota  db 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h
				db 05h, "                                                       ", 05h
				db 04h, "                                                       ", 04h
				db 06h, "                                                       ", 06h
				db 03h, "                                                       ", 03h
				db 05h, "              Lamentamos haberte secado.               ", 05h
				db 04h, "                                                       ", 04h
				db 06h, "            ­Vuelve cuando tengas dinero!              ", 06h
				db 03h, "                                                       ", 03h
				db 05h, "                                                       ", 05h
				db 04h, "                                                       ", 04h
				db 06h, "                                                       ", 06h
				db 03h, "        Y no olvides presionar cualquier tecla...      ", 03h
				db 05h, "                  ...antes de irte                     ", 05h
				db 04h, "                                                       ", 04h
				db 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h

cartel_abandono db 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h
				db 05h, "                                                       ", 05h
				db 04h, "                                                       ", 04h
				db 06h, "                                                       ", 06h
				db 03h, "                                                       ", 03h
				db 05h, "           ¨Eso es todo lo que puedes dar?             ", 05h
				db 04h, "                                                       ", 04h
				db 06h, "  Quiz s deber¡as buscar una mesa de menor jerarqu¡a.  ", 06h
				db 03h, "                                                       ", 03h
				db 05h, "                                                       ", 05h
				db 04h, "                                                       ", 04h
				db 06h, "                                                       ", 06h
				db 03h, "        Y no olvides presionar cualquier tecla...      ", 03h
				db 05h, "                  ...antes de irte                     ", 05h
				db 04h, "                                                       ", 04h
				db 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h


cartel_400c 	db 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h
				db 05h, "                                                       ", 05h
				db 04h, "                                                       ", 04h
				db 06h, "                                                       ", 06h
				db 03h, "                                                       ", 03h
				db 05h, "                 ­Alcanzaste los 400 C!                ", 05h
				db 04h, "                                                       ", 04h
				db 06h, "         Ya es hora de conservar las ganancias.        ", 06h
				db 03h, "                                                       ", 03h
				db 05h, "                                                       ", 05h
				db 04h, "                                                       ", 04h
				db 06h, "                                                       ", 06h
				db 03h, "        Y no olvides presionar cualquier tecla...      ", 03h
				db 05h, "                  ...antes de irte                     ", 05h
				db 04h, "                                                       ", 04h
				db 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h

cartel_al_hilo 	db 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h
				db 05h, "                                                       ", 05h
				db 04h, "                                                       ", 04h
				db 06h, "                                                       ", 06h
				db 03h, "                                                       ", 03h
				db 05h, "                  ¨Cinco manos seguidas?               ", 05h
				db 04h, "                                                       ", 04h
				db 06h, "          ­Eso parece ser algo m s que suerte!         ", 06h
				db 03h, "                                                       ", 03h
				db 05h, "          Te invitamos cort‚smente a retirarte.        ", 05h
				db 04h, "                                                       ", 04h
				db 06h, "                                                       ", 06h
				db 03h, "        Y no olvides presionar cualquier tecla...      ", 03h
				db 05h, "                  ...antes de irte                     ", 05h
				db 04h, "                                                       ", 04h
				db 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h

cartel_creditos db 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h
				db 05h, "                                                       ", 05h
				db 04h, "                       BLACKJACK                       ", 04h
				db 06h, "                                                       ", 06h
				db 03h, "    Programa basado en un Trabajo Pr ctico grupal para ", 03h
				db 05h, " la materia:                                           ", 05h
				db 04h, "                   ", 03h
				db "                 ", 03h
				db "                 ", 03h
				db 06h, "           SISTEMAS DE PROCESAMIENTO DE DATOS          ", 06h
				db 03h, "                          ", 03h
				db "                ", 03h
				db "           ", 03h
				db 05h, "               UNIVERSIDAD DE SAN MART¡N               ", 05h
				db 04h, "                                                       ", 04h
				db 06h, " La presente versi¢n fue dise¤ada, escrita y comentada ", 06h
				db 03h, "                                                       ", 03h
				db 05h, "             por MAURO DONNANTUONI MORATTO             ", 05h
				db 04h, "                                                       ", 04h
				db 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h

cartel_adios 	db 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h
				db 05h, "                                                       ", 05h
				db 04h, "                                                       ", 04h
				db 06h, "                        ­ADIOS!                        ", 06h
				db 03h, "                                                       ", 03h
				db 05h, "      Esperamos que hayas disfrutado del juego...      ", 05h
				db 04h, "                                                       ", 04h
				db 06h, "             y recomi‚ndanos a tus amigos.             ", 06h
				db 03h, "                                                       ", 03h
				db 05h, "                                                       ", 05h
				db 04h, "                                                       ", 04h
				db 06h, "                                                       ", 06h
				db 03h, "        Y no olvides presionar cualquier tecla...      ", 03h
				db 05h, "                  ...antes de irte                     ", 05h
				db 04h, "                                                       ", 04h
				db 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h

cartel_instruc1	db 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h
				db 05h, "                                                       ", 05h
				db 04h, "               BIENVENIDO/A A BLACKJACK                ", 04h
				db 06h, "                                                       ", 06h
				db 03h, "    Este programa intenta simular una mesa de apuestas ", 03h
				db 05h, " del c‚lebre juego de cartas, controlando el correcto  ", 05h
				db 04h, " desarrollo de las diversas circunstancias y alterna-  ", 04h
				db 06h, " tivas t¡picas de sus versiones cl sicas.              ", 06h
				db 03h, "                                                       ", 03h
				db 05h, "    El objetivo es simple: ganarle al crupier obte-    ", 05h
				db 04h, " niendo el puntaje m s cercano a 21, sin pasarse del   ", 04h
				db 06h, " mismo. Las figuras (J,Q,K) valen 10; el As vale 11, o ", 06h
				db 03h, " 1 si se superan los 21; y todas las otras cartas con- ", 03h
				db 05h, " servan el valor de su n£mero.                         ", 05h
				db 04h, "                                                       ", 04h
				db 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h

cartel_instruc2	db 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h
				db 05h, "                                                       ", 05h
				db 04h, " PASO A PASO DE UNA PARTIDA DE BLACKJACK:              ", 04h
				db 06h, "                                                       ", 06h
				db 03h, "    Al inicio de cada mano el jugador debe realizar su ", 03h
				db 05h, " apuesta. El crupier repartir  dos cartas descubiertas ", 05h
				db 04h, " para ‚l, y dos para s¡ mismo, pero la segunda quedar  ", 04h
				db 06h, " tapada. Si el primero obtiene 21 (As + 10) en esta    ", 06h
				db 03h, " instancia, obtiene Blackjack y s¢lo puede ser empata- ", 03h
				db 05h, " do por el crupier con otro Blackjack. En caso de ga-  ", 05h
				db 04h, " nar de este modo, la casa paga la apuesta 3x2. En ca- ", 04h
				db 06h, " so de empate, siempre se devuelve el pozo apostado.   ", 06h
				db 03h, "                                                       ", 03h
				db 05h, "    En cambio, si en el primer servicio no se obtuvo...", 05h
				db 04h, "                                                       ", 04h
				db 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h

cartel_instruc3	db 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h
				db 05h, "                                                       ", 05h
				db 04h, " ...Blackjack, el apostador puede doblar la apuesta, a ", 04h
				db 06h, " condici¢n de recibir una sola carta m s para comple-  ", 06h
				db 03h, " tar su juego. Si no dobla la apuesta, por contrapar-  ", 03h
				db 05h, " tida, puede solicitar tantas cartas como considere    ", 05h
				db 04h, " necesario, hasta plantarse. Si al pedir una nueva     ", 04h
				db 06h, " carta supera los 21, pierde su apuesta.               ", 06h
				db 03h, "                                                       ", 03h
				db 05h, "    Luego el crupier jugar  su mano. Sacar  tantas     ", 05h
				db 04h, " cartas como sea necesario para superar los 17 puntos. ", 04h
				db 06h, " El crupier nunca pierde con una mano blanda (alg£n As ", 06h
				db 03h, " valiendo 11), de modo que, en tal caso, seguir  to-   ", 03h
				db 05h, " mando cartas hasta superar los 17 con una mano dura.  ", 05h
				db 04h, "                                                       ", 04h
				db 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h

cartel_instruc4	db 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h
				db 05h, "                                                       ", 05h
				db 04h, "    Una vez que el crupier completa su mano, se eval£a ", 04h
				db 06h, " si obtuvo una suma superior a la del apostador (pero  ", 06h
				db 03h, " no mayor a 21). Si el apostador resulta ganador, se   ", 03h
				db 05h, " le paga su apuesta 1x1. Si pierde, la casa toma el    ", 05h
				db 04h, " pozo, y en caso de empate se devuelve al apostador.   ", 04h
				db 06h, "                                                       ", 06h
				db 03h, " ADVERTENCIA: este programa no cuenta con la opci¢n de ", 03h
				db 05h, " separar la mano, en caso de que las dos primeras car- ", 05h
				db 04h, " tas sean iguales. Si al usuario le tocan dos Ases en  ", 04h
				db 06h, " esta instancia, ambos tomar n el valor de uno. (El    ", 06h
				db 03h, " motivo de esta deficiencia est  relacionado con el    ", 03h
				db 05h, " dise¤o gr fico de la mesa de juego).                  ", 05h
				db 04h, "                                                       ", 04h
				db 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h

cartel_instruc5	db 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h
				db 05h, "                                                       ", 05h
				db 04h, " ADVERTENCIA 2: el juego baraja un s¢lo mazo de cartas ", 04h
				db 06h, " inglesas, de modo que bajo ninguna circunstancia pue- ", 06h
				db 03h, " de repetirse una misma carta en una misma mano.       ", 03h
				db 05h, "                                                       ", 05h
				db 04h, "                                                       ", 04h
				db 06h, "                                                       ", 06h
				db 03h, "                                                       ", 03h
				db 05h, "                                                       ", 05h
				db 04h, "                                                       ", 04h
				db 06h, "                                                       ", 06h
				db 03h, "                                                       ", 03h
				db 05h, "                                                       ", 05h
				db 04h, "                                                       ", 04h
				db 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h


cartel_instruc6	db 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h
				db 05h, "                                                       ", 05h
				db 04h, " CONDICIONES DE FINALIZACI¢N:                          ", 04h
				db 06h, "                                                       ", 06h
				db 03h, "    (1) Si el apostador se queda sin cr‚dito, es invi- ", 03h
				db 05h, "        tado a retirarse como un perdedor.             ", 05h
				db 04h, "    (2) Si supera los 400 C, es saludado como un ga-   ", 04h
				db 06h, "        nador legendario.                              ", 06h
				db 03h, "    (3) Si gana cinco manos seguidas, es sospechado de ", 03h
				db 05h, "        contador de cartas, y la casa lo invita a re-  ", 05h
				db 04h, "        tirarse, amparada en el derecho de admisi¢n.   ", 04h
				db 06h, "                                                       ", 06h
				db 03h, "    En los dos £ltimos casos, sumar  una victoria en   ", 03h
				db 05h, " su carrera gloriosa hacia el 'Sal¢n de la Fama'.      ", 05h
				db 04h, "                                                       ", 04h
				db 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h, 20h, 03h, 20h, 05h, 20h, 04h, 20h, 06h

;=============================== LETREROS ==================================================================

ingrese_usuario 	db "Ingrese su nombre, por favor: ", 24h

presione_tecla 		db "       Presiona cualquier tecla para continuar.", 24h

ingreso_incorrecto 	db "Ingreso incorrecto. Por favor, presta atenci¢n.", 24h

borrar_letrero 		db "                                                                 ", 24h

;================================= VARIABLES PARA EL SONIDO (funci¢n 'Cajita_musical') =====================

ruidito_ascendente dw 4060, 2710, 24h
ruidito_descendente dw 2710, 4060, 24h

ritmo_ruidito dw 2, 2

notas_gana 		dw 9116, 3618, 3042, 2279, 8122, 3415, 2710, 2030, 7235, 3042, 2415, 1809, 4558, 9116, 24h
ritmo_gana		dw    3,    3,    3,    3,    3,    3,    3,    3,    3,    3,    3,    3,    6,    6 

notas_pierde	dw 2279, 3042, 3618, 3042, 3618, 4558, 9116, 24h
ritmo_pierde	dw    4,    4,    4,    4,    4,    4,    7

;===================================== C¢DIGO ====================================================
.code

;==================================== FUNCIONES EXTERNAS ============================================
extrn Desarrollo_juego:proc
extrn Cajita_musical:proc
extrn Imprimir_cartel:proc
extrn Grabar_usuario:proc
extrn Modificar_salon_fama:proc
extrn Imprimir_salon:proc
extrn Limpiar_pantalla:proc
extrn Detencion_espera_tecla:proc
extrn Cuadro_dialogo:proc
extrn Borrar_cuadro_dialogo:proc
extrn Imprimir_letrero_inferior:proc
extrn Presentacion:proc
extrn Ingresar_usuario:proc

;=========================================== FUNCI¢N MAIN =============================================

main proc
	mov ax, @data
	mov ds, ax

 ;ESTABLECE EL MODO DE VIDEO PARA LA NAVEGACI¢N
	mov ah,00 ;modo texto
	mov al,03 ;modo 80x25 16 colores
	int 10h

;PRESENTACI¢N

	call Presentacion

	push offset ingrese_usuario
	push 1

	call Imprimir_letrero_inferior

	mov ah, 2 ;IMPRIMO UN ESPACIO PARA ESCAPAR DEL COLOR IMPUESTO POR LA FUNCI¢N ANTERIOR
	mov dl, ' '
	int 21h

;TOMA USUARIO
	call Ingresar_usuario

;GRABA EL USUARIO EN LOS CARTELES QUE CORRESPONDE
	push offset cartel_400c
	call Grabar_usuario

	push offset cartel_derrota
	call Grabar_usuario

	push offset cartel_al_hilo
	call Grabar_usuario

	push offset cartel_abandono
	call Grabar_usuario

	push offset ruidito_ascendente
	push offset ritmo_ruidito

	call Cajita_musical

	call Limpiar_pantalla

;============MENU===============================
impresion_menu:
	push offset borrar_letrero
	push 0

	call Imprimir_letrero_inferior

	push offset cartel_menu
	push 0

	call Imprimir_cartel
	
	call Detencion_espera_tecla

	push offset ruidito_ascendente
	push offset ritmo_ruidito

	call Cajita_musical

	jmp opciones_menu

vuelve_ingreso_incorrecto:
	call Detencion_espera_tecla

	push offset ruidito_descendente
	push offset ritmo_ruidito

	call Cajita_musical

;BORRA EL CARTEL DE FALLO, SI EST  IMPRESO
	push offset borrar_letrero
	push 0

	call Imprimir_letrero_inferior

opciones_menu:
    cmp al,31h
    je opcion1
    cmp al,32h
    je opcion2
    cmp al,33h
    je opcion3
    cmp al,34h 
    je opcion4
    cmp al,35h
    je opcion5
    cmp al,30h
    jle error0
    cmp al,36h
    jge error0

opcion2:
	jmp opc2

opcion3:
	jmp opc3

opcion4:
	jmp opc4

opcion5:
	jmp salir_programa

error0:
    jmp error
    
;OPCI¢N 1: JUEGO
opcion1:
	call Desarrollo_juego

	cmp dx, 0
	je pierde
	cmp dx, 1
	je gana_400
	cmp dx, 2
	je gana_5alhilo
	cmp dx, 3
	je abandono

pierde:
	push offset cartel_derrota
	jmp derrota

abandono:
	push offset cartel_abandono

derrota:
	push 1

	call Imprimir_cartel

	push offset notas_pierde
	push offset ritmo_pierde

	call Cajita_musical

	call Detencion_espera_tecla

	push offset ruidito_descendente
	push offset ritmo_ruidito

	call Cajita_musical

	jmp impresion_menu

gana_400:
	push offset cartel_400c

	jmp triunfo

gana_5alhilo:
	push offset cartel_al_hilo

	jmp triunfo

triunfo:
	push 1
	call Imprimir_cartel

	push offset notas_gana
	push offset ritmo_gana

	call Cajita_musical

	call Detencion_espera_tecla

	call Modificar_salon_fama ;GESTI¢N SAL¢N DE LA FAMA

	call Detencion_espera_tecla

	push offset ruidito_ascendente
	push offset ritmo_ruidito

	call Cajita_musical

	call Imprimir_salon

	push offset presione_tecla
    push 1

    call Imprimir_letrero_inferior
	
	call Detencion_espera_tecla

	push offset ruidito_descendente
	push offset ritmo_ruidito

	call Cajita_musical

	jmp impresion_menu

;OPCI¢N 2: INSTRUCCIONES Y PARTICULARIDADES
opc2:
	push offset cartel_instruc1 ;LLAMA CARTEL 1
	push 0

	call Imprimir_cartel

	push offset presione_tecla
	push 1

	call Imprimir_letrero_inferior

	call Detencion_espera_tecla

	push offset ruidito_ascendente
	push offset ritmo_ruidito

	call Cajita_musical

	push offset cartel_instruc2 ;LLAMA CARTEL 2
	push 0

	call Imprimir_cartel

	push offset presione_tecla
	push 1

	call Imprimir_letrero_inferior

	call Detencion_espera_tecla

	push offset ruidito_descendente
	push offset ritmo_ruidito

	call Cajita_musical

	push offset cartel_instruc3 ;LLAMA CARTEL 3
	push 0

	call Imprimir_cartel

	push offset presione_tecla
	push 1

	call Imprimir_letrero_inferior

	call Detencion_espera_tecla

	push offset ruidito_descendente
	push offset ritmo_ruidito

	call Cajita_musical

	push offset cartel_instruc4 ;LLAMA CARTEL 4
	push 0

	call Imprimir_cartel

	push offset presione_tecla
	push 1

	call Imprimir_letrero_inferior

	call Detencion_espera_tecla

	push offset ruidito_descendente
	push offset ritmo_ruidito

	call Cajita_musical

	push offset cartel_instruc5 ;LLAMA CARTEL 5
	push 0

	call Imprimir_cartel

	push offset presione_tecla
	push 1

	call Imprimir_letrero_inferior

	call Detencion_espera_tecla

	push offset ruidito_descendente
	push offset ritmo_ruidito

	call Cajita_musical

	push offset cartel_instruc6 ;LLAMA CARTEL 6
	push 0

	call Imprimir_cartel

	push offset presione_tecla
	push 1

	call Imprimir_letrero_inferior

	call Detencion_espera_tecla

	push offset ruidito_ascendente
	push offset ritmo_ruidito

	call Cajita_musical

	jmp impresion_menu

;OPCI¢N 3: SAL¢N DE LA FAMA
opc3:
    call Imprimir_salon

    push offset presione_tecla
    push 1

    call Imprimir_letrero_inferior

    call Detencion_espera_tecla

    push offset ruidito_descendente
	push offset ritmo_ruidito

	call Cajita_musical

    jmp impresion_menu

;OPCI¢N 4: CR‚DITOS
opc4:
	push offset cartel_creditos
    push 0

    call Imprimir_cartel

    push offset presione_tecla
    push 1

    call Imprimir_letrero_inferior

    call Detencion_espera_tecla

    push offset ruidito_descendente
	push offset ritmo_ruidito

	call Cajita_musical

    jmp impresion_menu

error: 
    push offset ingreso_incorrecto
	push 1

	call Imprimir_letrero_inferior

    jmp vuelve_ingreso_incorrecto

salir_programa:
	push offset cartel_adios
	push 1

	call Imprimir_cartel

	call Detencion_espera_tecla

	push offset ruidito_descendente
	push offset ritmo_ruidito

	call Cajita_musical

	call Limpiar_pantalla

	mov ax, 4c00h
	int 21h
main endp

end
