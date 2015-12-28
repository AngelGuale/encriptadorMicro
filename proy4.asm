	LIST		p=16F887		; Tipo de microcontrolador
	INCLUDE 	P16F887.INC		; Define los SFRs y bits del							; P16F887

	__CONFIG _CONFIG1, _CP_OFF&_WDT_OFF&_INTOSCIO	
						; Ingresa parámetros de 
						; Configuración

	errorlevel	 -302			; Deshabilita mensajes de 
						; Advertencia por cambio 
						; Bancos

	CBLOCK	0X20	
	OPCION
	tempTMR0
	temp1ms
	temp
	FLECHA1
	FLECHA2
	FLECHA3
	LETRA1
	LETRA1H
	LETRA1L
	LETRA2
	LETRA2H
	LETRA2L
	LETRA3
	LETRA3H
	LETRA3L
	LETRA4
	LETRA4H
	LETRA4L
	LETRA5
	LETRA5H
	LETRA5L
	d1	;para el delay de 1seg
	d2
	d3
	f1	;para el delay de 250ms
	f2
	musica_enable
	select_music
	counter2
	ENDC
;*********************************************************************			
; INICIO DEL PROGRAMA 

	ORG 	0x00			; Comienzo del programa (Vector de Reset)
	GOTO	MAIN
	ORG		0X04
	GOTO	INTER

encripta_x_16
	movfw PORTD	
	movwf counter2
	bcf STATUS, C
	rlf counter2,1
	bcf STATUS, C
	rlf counter2,1 
	bcf STATUS, C
	rlf counter2,1 
	bcf STATUS, C
	rlf counter2,1
	movfw counter2
	movwf PORTC
	;goto fin_int
	return
encripta_x_4
	movfw PORTD	
	movwf counter2
	bcf STATUS, C
	rlf counter2,1
	bcf STATUS, C
	rlf counter2,1 
	movfw counter2
movwf PORTC	
;goto fin_int
	return
encripta_x_2
	movfw PORTD	
	movwf counter2
	bcf STATUS, C
	rlf counter2,1
	movfw counter2
	;goto fin_int
movwf PORTC
	return
INTER
	BTFSC		INTCON, RBIF	;si la bandera del TMR0 se activo, va a la funcion INTTMR0
	GOTO		INTRB
	BTFSC		INTCON,T0IF
	GOTO		INTTMR0
	BTFSC		INTCON, INTF
	GOTO 		RBCINTERR 		
	RETFIE

RBCINTERR 
	movlw b'11111111'
	movwf musica_enable
	BCF			INTCON, INTF
	movfw   PORTD
	;btfsc   select_music,1
	;goto encripta_x_2
	;btfsc   select_music,0
	;goto encripta_x_4
	;goto encripta_x_16 
fin_int
	;movwf PORTC
	RETFIE
INTRB
	BCF			INTCON, RBIF
	MOVF		PORTB,F
	BCF			INTCON,0
	CLRW
	BTFSS		PORTB,0
	MOVLW		0X01
	
	;BTFSS		PORTB,1
	;MOVLW		0X02
	;BTFSS		PORTB,2
	;MOVLW		0X04
	;BTFSS		PORTB,3
	;MOVLW		0X08
	;BTFSS		PORTB,4
	;MOVLW		0X10
	;BTFSS		PORTB,5
	;MOVLW		0X20
;	BTFSS		PORTB,6
;	MOVLW		0X40
;	BTFSS		PORTB,7
;	MOVLW		0X80
	MOVWF		OPCION
	RETFIE

INTTMR0
	BCF			INTCON,T0IF
	BTFSC		PORTE,0
	GOTO		hacer0
	BSF			PORTE,0
	MOVF		tempTMR0,w
	MOVWF		TMR0
	RETFIE
hacer0
	BCF			PORTE,0
	MOVF		tempTMR0,w
	MOVWF		TMR0
	RETFIE
	
; SETEO DE PUERTOS 
MAIN	
	BANKSEL 	TRISB		; selecciona el banco conteniendo TRISB
	MOVLW		0XB1
	MOVWF		OPTION_REG	; TMR0 CON PRESCALADOR 1:4 Y PULLUP ACTIVADO
	COMF		IOCB,F
	MOVLW		0XB8
	MOVWF		INTCON		; HABILITA INTERRUPCIONES X CAMBIO DE ESTADO PORTB Y TMR0
	CLRF		TRISC
	CLRF		TRISD
	CLRF		TRISE
	BANKSEL		ANSEL
	CLRF		ANSEL	; configura puertos con entradas digitales
	CLRF		ANSELH	; configura puertos con entradas digitales
	BANKSEL 	PORTC	; selecciona el puerto B como salida
	MOVLW		0XFF
	MOVWF		PORTB
	CLRF		PORTE
	CLRF		OPCION
	MOVLW		B'10010000'
	MOVWF		FLECHA1
	MOVLW		B'01001000'
	MOVWF		FLECHA2
	MOVLW		B'00100100'
	MOVWF		FLECHA3
	MOVLW		B'01000101'
	MOVWF		LETRA1
	MOVLW		B'01010101'
	MOVWF		LETRA1H
	CLRF		LETRA1L
	CLRF		LETRA2
	MOVLW		B'00100000'
	MOVWF		LETRA2H
	CLRF		LETRA2L
	CLRF		LETRA3
	MOVLW		B'00000010'
	MOVWF		LETRA3H
	CLRF		LETRA3L
	MOVLW		B'00110000'
	MOVWF		LETRA4
	CLRF		LETRA4H
	CLRF		LETRA4L
	MOVLW		B'00000010'
	MOVWF		LETRA5
	CLRF		LETRA5H
	CLRF		LETRA5L
	clrf musica_enable
	clrf select_music
	clrf PORTC
; DESARROLLO DEL PROGRAMA

LOOP
	;CLRF		PORTC
	CLRF		PORTD
	;MOVF		OPCION,F
	;BTFSC		STATUS,Z
	;GOTO		LOOP	
	;BTFSC		OPCION,0
	;GOTO		MOV1
	;BTFSC		OPCION,1
	;GOTO		MUSIC1
	;BTFSC		OPCION,2
	;GOTO		MOV2
	;BTFSC		OPCION,3
	;GOTO		MOV3
	;BTFSC		OPCION,4
	;GOTO		MUSIC1
	;BTFSC		OPCION,5
	;GOTO		MUSIC2
	incf select_music
	movlw 	b'11111111'
	subwf 	musica_enable, W
	BTFSS		STATUS,Z
	GOTO 		LOOP
	btfsc   select_music,1
	goto MUSIC3
	btfsc   select_music,0
	goto MUSIC2
	goto MUSIC1
;*******************SUBRUTINAS***************
delay1ms
	MOVLW		.100
	MOVWF		temp1ms
sigue
	NOP
	DECFSZ		temp1ms,F
	GOTO		sigue
	RETURN

delay1seg
			;999990 cycles
	movlw	0x07
	movwf	d1
	movlw	0x2F
	movwf	d2
	movlw	0x03
	movwf	d3
delay_1seg_0
	decfsz	d1, f
	goto	$+2
	decfsz	d2, f
	goto	$+2
	decfsz	d3, f
	goto	delay_1seg_0
			;6 cycles
	goto	$+1
	goto	$+1
	goto	$+1

			;4 cycles (including call)
	return

delay250ms
			;249993 cycles
	movlw	0x4E
	movwf	f1
	movlw	0xC4
	movwf	f2
delay250ms_0
	decfsz	f1, f
	goto	$+2
	decfsz	f2, f
	goto	delay250ms_0

			;3 cycles
	goto	$+1
	nop

			;4 cycles (including call)
	return

SIN_NOTA
	BCF		PORTE,0
	BANKSEL	OPTION_REG
	BSF		OPTION_REG,T0CS
	MOVLW		0X96		;aprox 150 repeticiones (150ms)
	MOVWF		temp
	CALL		delay1ms
	DECFSZ		temp,F
	GOTO		$-2
	BCF		OPTION_REG,T0CS
	BANKSEL	PORTA

DO
	MOVLW	0X11
	MOVWF	TMR0
	MOVWF	tempTMR0
	RETURN
RE
	MOVLW	0X2C
	MOVWF	TMR0
	MOVWF	tempTMR0
	RETURN
MI
	MOVLW	0X42
	MOVWF	TMR0
	MOVWF	tempTMR0
	RETURN
FA
	MOVLW	0X4D
	MOVWF	TMR0
	MOVWF	tempTMR0
	RETURN
SOL
	MOVLW	0X60
	MOVWF	TMR0
	MOVWF	tempTMR0
	RETURN
LA
	MOVLW	0X72
	MOVWF	TMR0
	MOVWF	tempTMR0
	RETURN
SI
	MOVLW	0X82
	MOVWF	TMR0
	MOVWF	tempTMR0
	RETURN
do
	MOVLW	0X88
	MOVWF	TMR0
	MOVWF	tempTMR0
	RETURN
re
	MOVLW	0X96
	MOVWF	TMR0
	MOVWF	tempTMR0
	RETURN
mi
	MOVLW	0XA1
	MOVWF	TMR0
	MOVWF	tempTMR0
	RETURN
fa
	MOVLW	0XA6
	MOVWF	TMR0
	MOVWF	tempTMR0
	RETURN
sol
	MOVLW	0XB0
	MOVWF	TMR0
	MOVWF	tempTMR0
	RETURN
la
	MOVLW	0XB9
	MOVWF	TMR0
	MOVWF	tempTMR0
	RETURN
si
	MOVLW	0XC0
	MOVWF	TMR0
	MOVWF	tempTMR0
	RETURN
;MOV1
;	BANKSEL		OPTION_REG
;	BSF			OPTION_REG,T0CS
;	BANKSEL		PORTA
;	CLRF		temp
;MOV1_1
;	MOVLW		B'11000011'
;	MOVWF		PORTC
;	MOVLW		B'11101111'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVLW		B'00100100'
;	MOVWF		PORTC
;	MOVLW		B'00101100'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVLW		B'00011000'
;	MOVWF		PORTC
;	MOVLW		B'00000011'
;	MOVWF		PORTD
;	CALL		delay1ms
;	DECFSZ		temp,F
;	GOTO		MOV1_1
;;***************************************
;	CLRF		temp
;MOV1_2
;	MOVLW		B'10000000'
;	MOVWF		PORTC
;	MOVLW		B'10111111'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVLW		B'01000000'
;	MOVWF		PORTC
;	MOVLW		B'11011111'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVLW		B'00000011'
;	MOVWF		PORTC
;	MOVLW		B'11101111'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVLW		B'00100100'
;	MOVWF		PORTC
;	MOVLW		B'00101100'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVLW		B'00011000'
;	MOVWF		PORTC
;	MOVLW		B'00000011'
;	MOVWF		PORTD
;	CALL		delay1ms
;	DECFSZ		temp,F
;	GOTO		MOV1_2
;	GOTO		LOOP
;
;MOV2
;	BANKSEL		OPTION_REG
;	BSF			OPTION_REG,T0CS
;	BANKSEL		PORTA
;	MOVLW		0X64		;aprox 100 repeticiones (100ms)
;	MOVWF		temp
;	CALL		delay1ms
;	DECFSZ		temp,F
;	GOTO		$-2
;	MOVLW		0X50		;velocidad del cambio (80ms)
;	MOVWF		temp
;
;MOV2_1
;	MOVF		FLECHA1,W
;	MOVWF		PORTC
;	MOVLW		B'11101111'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVF		FLECHA2,W
;	MOVWF		PORTC
;	MOVLW		B'11010111'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVF		FLECHA3,W
;	MOVWF		PORTC
;	MOVLW		B'10111011'
;	MOVWF		PORTD
;	CALL		delay1ms
;	DECFSZ		temp,F
;	GOTO		MOV2_1
;;********************************
;	rlf			FLECHA1,F
;	movf		STATUS,W
;	andlw		0x01
;	iorwf		FLECHA1,F
;	bcf			STATUS,0
;	rlf			FLECHA2,f
;	movf		STATUS,W
;	andlw		0x01
;	iorwf		FLECHA2,f
;	bcf			STATUS,0
;	rlf			FLECHA3,f
;	movf		STATUS,W
;	andlw		0x01
;	iorwf		FLECHA3,f
;	bcf			STATUS,0
;	CALL		delay1ms
;
;	GOTO		LOOP
;
;MOV3
;	BANKSEL		OPTION_REG
;	BSF			OPTION_REG,T0CS
;	BANKSEL		PORTA
;	MOVLW		0X64		;aprox 100 repeticiones (100ms)
;	MOVWF		temp
;	CALL		delay1ms
;	DECFSZ		temp,F
;	GOTO		$-2
;	MOVLW		0X50		;velocidad del cambio (80ms)
;	MOVWF		temp
;MOV3_1
;	MOVF		LETRA1H,W
;	MOVWF		PORTC
;	MOVLW		B'10000011'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVF		LETRA2H,W
;	MOVWF		PORTC
;	MOVLW		B'11101111'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVF		LETRA3H,W
;	MOVWF		PORTC
;	MOVLW		B'10111011'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVF		LETRA4H,W
;	MOVWF		PORTC
;	MOVLW		B'11111011'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVF		LETRA5H,W
;	MOVWF		PORTC
;	MOVLW		B'10101111'
;	MOVWF		PORTD
;	CALL		delay1ms
;	DECFSZ		temp,F
;	GOTO		MOV3_1
;;***************************************
;	rlf			LETRA1L,F
;	rlf			LETRA1,F
;	rlf			LETRA1H,F
;	movf		STATUS,W
;	andlw		0x01
;	iorwf		LETRA1L,F
;	bcf			STATUS,0
;	rlf			LETRA2L,F
;	rlf			LETRA2,F
;	rlf			LETRA2H,F
;	movf		STATUS,W
;	andlw		0x01
;	iorwf		LETRA2L,F
;	bcf			STATUS,0
;	rlf			LETRA3L,F
;	rlf			LETRA3,F
;	rlf			LETRA3H,F
;	movf		STATUS,W
;	andlw		0x01
;	iorwf		LETRA3L,F
;	bcf			STATUS,0
;	rlf			LETRA4L,F
;	rlf			LETRA4,F
;	rlf			LETRA4H,F
;	movf		STATUS,W
;	andlw		0x01
;	iorwf		LETRA4L,F
;	bcf			STATUS,0
;	rlf			LETRA5L,F
;	rlf			LETRA5,F
;	rlf			LETRA5H,F
;	movf		STATUS,W
;	andlw		0x01
;	iorwf		LETRA5L,F
;	bcf			STATUS,0
;	CALL		delay1ms
;
;	GOTO		LOOP
;
;MOV4
;	BANKSEL		OPTION_REG
;	BSF			OPTION_REG,T0CS
;	BANKSEL		PORTA
;	CLRF		TMR0
;	CLRF		temp
;MOV4_1
;	MOVLW		B'10000001'
;	MOVWF		PORTC
;	MOVLW		B'11000011'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVLW		B'01000000'
;	MOVWF		PORTC
;	MOVLW		B'10111101'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVLW		B'00100000'
;	MOVWF		PORTC
;	MOVLW		B'01011110'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVLW		B'00010000'
;	MOVWF		PORTC
;	MOVLW		B'01110110'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVLW		B'00001100'
;	MOVWF		PORTC
;	MOVLW		B'01100110'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVLW		B'00000010'
;	MOVWF		PORTC
;	MOVLW		B'10100101'
;	MOVWF		PORTD
;	CALL		delay1ms
;	DECFSZ		temp,F
;	GOTO		MOV4_1
;;***************************************
;	CLRF		temp
;MOV4_2
;	MOVLW		0X80
;	MOVWF		PORTC
;	MOVLW		B'11000011'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVLW		0X40
;	MOVWF		PORTC
;	MOVLW		B'10111101'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVLW		0X20
;	MOVWF		PORTC
;	MOVLW		B'01011110'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVLW		0X10
;	MOVWF		PORTC
;	MOVLW		B'01110110'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVLW		0X08
;	MOVWF		PORTC
;	MOVLW		B'01100110'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVLW		0X04
;	MOVWF		PORTC
;	MOVLW		B'01010110'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVLW		0X02
;	MOVWF		PORTC
;	MOVLW		B'10110101'
;	MOVWF		PORTD
;	CALL		delay1ms
;
;	MOVLW		0X01
;	MOVWF		PORTC
;	MOVLW		B'11110011'
;	MOVWF		PORTD
;	CALL		delay1ms
;	DECFSZ		temp,F
;	GOTO		MOV4_2
;	GOTO		LOOP
;
MUSIC1
	BANKSEL		OPTION_REG
	BCF			OPTION_REG,T0CS
	BANKSEL		PORTA
	
	CALL encripta_x_16
	CALL		DO
	CALL		delay1seg
	CALL		RE
	CALL		delay1seg
	CALL		MI
	CALL		delay1seg

	
	BANKSEL		OPTION_REG
	BSF			OPTION_REG,T0CS
	BANKSEL		PORTA
	clrf musica_enable
	
	GOTO		LOOP

MUSIC2
	BANKSEL		OPTION_REG
	BCF			OPTION_REG,T0CS
	BANKSEL		PORTA

	CALL encripta_x_4
	CALL		DO
	CALL		delay250ms
	CALL		delay250ms
	CALL		SOL
	CALL		delay1seg
	CALL		DO
	CALL		delay1seg
	CALL		delay1seg

	
	
	BANKSEL		OPTION_REG
	BSF			OPTION_REG,T0CS
	BANKSEL		PORTA
	CALL		delay1seg
	clrf musica_enable
	GOTO		LOOP

MUSIC3
	BANKSEL		OPTION_REG
	BCF			OPTION_REG,T0CS
	BANKSEL		PORTA

	CALL encripta_x_2
	CALL		SI
	CALL		delay250ms
	CALL		delay250ms
	CALL		SI
	CALL		delay1seg
	CALL		LA
	CALL		delay1seg
	CALL		delay1seg

	
	
	BANKSEL		OPTION_REG
	BSF			OPTION_REG,T0CS
	BANKSEL		PORTA
	CALL		delay1seg
	clrf musica_enable
	GOTO		LOOP

END					; fin del programa