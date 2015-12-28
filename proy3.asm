 
	LIST		p=16F887
	INCLUDE 	P16F887.INC	
	__CONFIG _CONFIG1, _CP_OFF&_WDT_OFF&_INTOSCIO
	errorlevel	 -302	
;**********************************************************	
	CBLOCK	0X020	
	contador		
	unidades	
	uni_cod		
	decenas	
	dec_cod		
	d1
	d2
	d3
	f1
	f2
	temp1ms
	sel
	dcont
	o
	m
	n
	terminoD
	tsupp
	tinf
	aux	
	ENDC
;**********************************************************
;PROGRAMA
	ORG	0x00		
	GOTO	MAIN
	ORG	0x04		
	GOTO	Interrupcion	

tabla2
		clrf	aux
		movwf	aux
		movlw	.15
		subwf	aux,w
		btfsc	STATUS,2
		goto	quince_F
		movlw	.14
		subwf	aux,w
		btfsc	STATUS,2
		goto	catorce_E
		movlw	.13
		subwf	aux,w
		btfsc	STATUS,2
		goto	trece_D
		movlw	.12
		subwf	aux,w
		btfsc	STATUS,2
		goto	doce_C
		movlw	.11
		subwf	aux,w
		btfsc	STATUS,2
		goto	once_B
		movlw	.10
		subwf	aux,w
		btfsc	STATUS,2
		goto	diez_A
		movlw	.9
		subwf	aux,w
		btfsc	STATUS,2
		goto	nueve
		movlw	.8
		subwf	aux,w
		btfsc	STATUS,2
		goto	ocho
		movlw	.7
		subwf	aux,w
		btfsc	STATUS,2
		goto	siete
		movlw	.6
		subwf	aux,w
		btfsc	STATUS,2
		goto	seis
		movlw	.5
		subwf	aux,w
		btfsc	STATUS,2
		goto	cinco
		movlw	.4
		subwf	aux,w
		btfsc	STATUS,2
		goto	cuatro
		movlw	.3
		subwf	aux,w
		btfsc	STATUS,2
		goto	tres
		movlw	.2
		subwf	aux,w
		btfsc	STATUS,2
		goto	dos
		movlw	.1
		subwf	aux,w
		btfsc	STATUS,2
		goto	uno
		movf	aux,f
		btfsc	STATUS,2
		goto	cero
		return		

tabla
       	ADDWF   PCL,F       
       	RETLW   0x3F     
		RETLW	0x06	
		RETLW	0x5B	
		RETLW	0x4F	
		RETLW	0x66	
		RETLW	0x6D		
		RETLW	0x7D	
		RETLW	0x07	
		RETLW	0x7F	
		RETLW	0x67
	
Interrupcion  
	movf	sel,w		
	btfss	STATUS,2	
	goto	dig2
dig1	 	
	movf	unidades,w  
	call	tabla
	movwf	uni_cod
	movf 	uni_cod,w
	bsf		PORTE,0
	bsf		PORTE,1
	movwf	PORTB
	bcf		PORTE,0
	comf	sel,f
	goto 	Seguir
dig2	
	movf	decenas,w  
	call	tabla
	movwf	dec_cod
	movf 	dec_cod,w
	bsf		PORTE,0
	bsf		PORTE,1
	movwf	PORTB
	bcf		PORTE,1
	comf	sel,f

Seguir   
	bcf	INTCON,T0IF		
	movlw 	~.39
    movwf 	TMR0      	
    retfie			

MAIN
;SETEO DE PUERTOS 
	BANKSEL	ANSEL		
	CLRF		ANSEL
	CLRF		ANSELH
	BANKSEL 	TRISD		
	movlw		0xFF
	movwf		TRISD
	CLRF		TRISA		
	clrf		TRISB
	
	CLRF		TRISC
	CLRF		TRISE

;INICIALIZACION	      
	BANKSEL 	PORTD				
	CLRF		PORTA		
	CLRF		PORTB
	CLRF		PORTC
	CLRF 		PORTE
	clrf		unidades
	clrf		decenas
	clrf		sel
	clrf		terminoD		                                                                         

;PROGRAMACION DEL TMR0
	banksel		OPTION_REG  	
	movlw		b'00000111'	
	movwf		OPTION_REG  	
	BANKSEL		TMR0		
	movlw		.217	
	movwf		TMR0	
	clrf		contador
	movlw		.30
	movwf		dcont
	movlw		b'10000000'
	movwf		INTCON

entrada
	CLRF	PORTA
	CLRF	PORTC
	
loop
	call	matrix
	;call 	click
	;call	delay250ms
	goto 	entrada
	
matrix
	movlw	b'11110000'
	;movf	PORTD,0
	movwf	terminoD
	movwf	tsupp
	;movwf	tinf
	call	termino_superior
	;call	termino_inferior
	movf	tsupp,0
	;movlw 	b'00001111'
	;movwf	PORTB
dibuja
	movfw PORTD	
	call	tabla2
	goto dibuja	
return

termino_superior
	bcf		STATUS,0
	rrf		tsupp
	bcf		STATUS,0
	rrf		tsupp
	bcf		STATUS,0
	rrf		tsupp
	bcf		STATUS,0
	rrf		tsupp
	return

termino_inferior
	movlw	b'00001111'
	andwf	tinf,f
	return

click	
	INCF 	unidades,f		
	movlw	.10
	subwf	unidades,w
	btfss	STATUS,2
	return
	clrf	unidades
	incf	decenas
	movlw	.10
	subwf	decenas,w
	btfss	STATUS,2
	return
	clrf	decenas
	return

; TABLA DE CONVERSION---------------------------------------------------------

; FIGURAS ---------------------------------------

cero
	bcf		STATUS,2
	movlw 	b'01111101'
	movwf	PORTC
	movlw	b'00111000'
	movwf	PORTA
	call	simple_delay
	
	movlw	b'10000011'
	movwf	PORTC
	movlw	b'01000100'
	movwf	PORTA
	call	simple_delay

	decfsz	dcont,1
	goto 	cero

	movlw	.20
	movwf	dcont
	return

uno
	bcf		STATUS,2
	movlw 	b'11111101'
	movwf	PORTC
	movlw	b'00001000'
	movwf	PORTA
	call	simple_delay
	
	movlw	b'11111011'
	movwf	PORTC
	movlw	b'00011000'
	movwf	PORTA
	call	simple_delay

	movlw	b'11110111'
	movwf	PORTC
	movlw	b'00101000'
	movwf	PORTA
	call	simple_delay

	movlw	b'10001111'
	movwf	PORTC
	movlw	b'00001000'
	movwf	PORTA
	call	simple_delay

	movlw	b'01111111'
	movwf	PORTC
	movlw	b'000111100'
	movwf	PORTA
	call	simple_delay


	decfsz	dcont,1
	goto 	uno

	movlw	.20
	movwf	dcont
	return

dos
	bcf		STATUS,2
	movlw 	b'01101101'
	movwf	PORTC
	movlw	b'00111100'
	movwf	PORTA
	call	simple_delay
	
	movlw	b'11110011'
	movwf	PORTC
	movlw	b'00000100'
	movwf	PORTA
	call	simple_delay

	movlw	b'10011111'
	movwf	PORTC
	movlw	b'00100000'
	movwf	PORTA
	call	simple_delay


	decfsz	dcont,1
	goto 	dos

	movlw	.20
	movwf	dcont
	return

tres
	bcf		STATUS,2
	movlw 	b'01101101'
	movwf	PORTC
	movlw	b'00111100'
	movwf	PORTA
	call	simple_delay
	
	movlw	b'10010011'
	movwf	PORTC
	movlw	b'00000100'
	movwf	PORTA
	call	simple_delay


	decfsz	dcont,1
	goto 	tres

	movlw	.20
	movwf	dcont
	return

cuatro
	bcf		STATUS,2
	movlw 	b'11110001'
	movwf	PORTC
	movlw	b'00100100'
	movwf	PORTA
	call	simple_delay
	
	movlw	b'11101111'
	movwf	PORTC
	movlw	b'00111100'
	movwf	PORTA
	call	simple_delay

	movlw	b'00011111'
	movwf	PORTC
	movlw	b'00000100'
	movwf	PORTA
	call	simple_delay

	decfsz	dcont,1
	goto 	cuatro

	movlw	.20
	movwf	dcont
	return

cinco
	bcf		STATUS,2
	movlw 	b'01101101'
	movwf	PORTC
	movlw	b'00111100'
	movwf	PORTA
	call	simple_delay
	
	movlw	b'11110011'
	movwf	PORTC
	movlw	b'00100000'
	movwf	PORTA
	call	simple_delay

	movlw	b'10011111'
	movwf	PORTC
	movlw	b'00000100'
	movwf	PORTA
	call	simple_delay

	decfsz	dcont,1
	goto 	cinco

	movlw	.20
	movwf	dcont
	return

seis
	bcf		STATUS,2
	movlw 	b'01101101'
	movwf	PORTC
	movlw	b'00111100'
	movwf	PORTA
	call	simple_delay
	
	movlw	b'11110011'
	movwf	PORTC
	movlw	b'00100000'
	movwf	PORTA
	call	simple_delay

	movlw	b'10011111'
	movwf	PORTC
	movlw	b'00100100'
	movwf	PORTA
	call	simple_delay

	decfsz	dcont,1
	goto 	seis

	movlw	.20
	movwf	dcont
	return

siete
	bcf		STATUS,2
	movlw 	b'11111101'
	movwf	PORTC
	movlw	b'01111000'
	movwf	PORTA
	call	simple_delay
	
	movlw	b'00010011'
	movwf	PORTC
	movlw	b'00001000'
	movwf	PORTA
	call	simple_delay

	movlw	b'11101111'
	movwf	PORTC
	movlw	b'00011100'
	movwf	PORTA
	call	simple_delay

	decfsz	dcont,1
	goto 	siete

	movlw	.20
	movwf	dcont
	return

ocho
	bcf		STATUS,2
	movlw 	b'01101101'
	movwf	PORTC
	movlw	b'00111000'
	movwf	PORTA
	call	simple_delay
	
	movlw	b'10010011'
	movwf	PORTC
	movlw	b'01000100'
	movwf	PORTA
	call	simple_delay

	decfsz	dcont,1
	goto 	ocho

	movlw	.20
	movwf	dcont
	return


nueve
	bcf		STATUS,2
	movlw 	b'01101101'
	movwf	PORTC
	movlw	b'00111100'
	movwf	PORTA
	call	simple_delay
	
	movlw	b'11110011'
	movwf	PORTC
	movlw	b'00100100'
	movwf	PORTA
	call	simple_delay

	movlw	b'00011111'
	movwf	PORTC
	movlw	b'00000100'
	movwf	PORTA
	call	simple_delay

	decfsz	dcont,1
	goto 	nueve

	movlw	.20
	movwf	dcont
	return

diez_A
	bcf		STATUS,2
	movlw 	b'11111101'
	movwf	PORTC
	movlw	b'00111000'
	movwf	PORTA
	call	simple_delay
	
	movlw	b'00010011'
	movwf	PORTC
	movlw	b'01000100'
	movwf	PORTA
	call	simple_delay

	movlw	b'11101111'
	movwf	PORTC
	movlw	b'01111100'
	movwf	PORTA
	call	simple_delay

	decfsz	dcont,1
	goto 	diez_A

	movlw	.20
	movwf	dcont
	return


once_B
	bcf		STATUS,2
	movlw 	b'01101101'
	movwf	PORTC
	movlw	b'01111000'
	movwf	PORTA
	call	simple_delay
	
	movlw	b'10010011'
	movwf	PORTC
	movlw	b'01100100'
	movwf	PORTA
	call	simple_delay

	decfsz	dcont,1
	goto 	once_B

	movlw	.20
	movwf	dcont
	return


doce_C
	bcf		STATUS,2
	movlw 	b'01111101'
	movwf	PORTC
	movlw	b'00011100'
	movwf	PORTA
	call	simple_delay
	
	movlw	b'10111011'
	movwf	PORTC
	movlw	b'00100000'
	movwf	PORTA
	call	simple_delay

	movlw	b'11000111'
	movwf	PORTC
	movlw	b'01000000'
	movwf	PORTA
	call	simple_delay


	decfsz	dcont,1
	goto 	doce_C

	movlw	.20
	movwf	dcont
	return

trece_D
	bcf		STATUS,2
	movlw 	b'01111101'
	movwf	PORTC
	movlw	b'01111000'
	movwf	PORTA
	call	simple_delay
	
	movlw	b'10111011'
	movwf	PORTC
	movlw	b'01100100'
	movwf	PORTA
	call	simple_delay

	movlw	b'11000111'
	movwf	PORTC
	movlw	b'01100010'
	movwf	PORTA
	call	simple_delay


	decfsz	dcont,1
	goto 	trece_D

	movlw	.20
	movwf	dcont
	return


catorce_E
	bcf		STATUS,2
	movlw 	b'01111101'
	movwf	PORTC
	movlw	b'01111100'
	movwf	PORTA
	call	simple_delay
	
	movlw	b'10000011'
	movwf	PORTC
	movlw	b'01100000'
	movwf	PORTA
	call	simple_delay

	movlw	b'11101111'
	movwf	PORTC
	movlw	b'01111100'
	movwf	PORTA
	call	simple_delay


	decfsz	dcont,1
	goto 	catorce_E

	movlw	.20
	movwf	dcont
	return

quince_F
	bcf		STATUS,2
	movlw	b'11111101'
	movwf	PORTC
	movlw 	b'01111100'
	movwf	PORTA
	call	simple_delay

	movlw	b'00000011'
	movwf	PORTC
	movlw	b'01100000'
	movwf	PORTA
	call	simple_delay

	movlw	b'11101111'
	movwf	PORTC
	movlw	b'01111000'
	movwf	PORTA
	call	simple_delay
	
	decfsz	dcont,1
	goto 	quince_F

	movlw	.20
	movwf	dcont
	;goto dibuja
	return	

delay1seg
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
	goto	$+1
	goto	$+1
	goto	$+1
	return

delay250ms
	movlw	0x4E
	movwf	f1
	movlw	0xC4
	movwf	f2
delay250ms_0
	decfsz	f1, f
	goto	$+2
	decfsz	f2, f
	goto	delay250ms_0
	goto	$+1
	nop
	return

delay1ms
	MOVLW		.100
	MOVWF		temp1ms
sigue
	NOP
	DECFSZ		temp1ms,F
	GOTO		sigue
	RETURN

simple_delay
	movlw	.1
	movwf	o
dtres
	movlw	.8
	movwf	m
ddos
	movlw	.250
	movwf	n
duno
	nop
	nop
	decfsz	n,1
	goto	duno
	decfsz	m,1
	goto	ddos
	decfsz	o,1
	goto	dtres
	return	

	

END ; FINAL