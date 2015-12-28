;*******************HEADER******************************************
;*******************************************************************

	LIST		p=16F887			
	INCLUDE 	P16F887.INC		
	__CONFIG _CONFIG1, _CP_OFF&_WDT_OFF&_XT_OSC	
	errorlevel	 -302	
;****************************************************
; bloque de variables
;*****************************************************		       

cblock 0x20
	counter1
	counter2
	counter3
	num_msj
	
	unidades	
	uni_cod		
	decenas	
	dec_cod		
	sel		

endc
;************************START OF PROGRAM ***********************
; forma de iniciar programa que usa interrupciones
;****************************************************************

       Org	0x00		; vector de reset
       Goto	main		; salto a label "main"
       Org	0x04        	; vector de interrupción  
       Goto	inter 		; salto a interrupción
       org	0x05  		; continuación de programa


;************************ MAIN PROGRAM *************************
; inicio de programa principal
;***************************************************************
;SETEO DE PUERTOS Y REGISTROS       	
main  
	banksel	ANSEL		;Bank containing register ANSEL
	clrf		ANSEL		;Clears registers ANSEL and ANSELH
	clrf		ANSELH		;All pins are digital

	banksel	TRISC	;Selects bank containing register TRISB
	movlw b'11111111'
	movwf		TRISC	;All port C pins are configured as outputs
	clrf		TRISD 	;All port D pins are configured as outputs
	banksel TRISA
	clrf 		TRISA
	bsf		TRISB,0	;PORTB,0 configurado como entrada
    banksel TRISE
	clrf 		TRISE
	             
   
	banksel	OPTION_REG	; Bank containing register OPTION_REG
	movlw		b'00000111'	;carga divisor con 255, se lo aplica a 
;TMR0
					;PSA =0 (BIT 3); se aplica el divisor 
;al TMR0
					;TOCS=0 (BIT 5); TMR0 origen de pulsos 
;Fosc/4
	movwf		OPTION_REG

	movlw		b'10110000'	;habilita interrupción por Timer 0 y Global
				;GIE=1 (BIT 7); habilita interrupciones 
;globales
;TMR0IE=1 (BIT 5); habilita interrupciones por 
;TMR0
 			    ;INTE=1 (BIT 4); habilita interrupciones por RB0  
	movwf		INTCON
 	
	clrf 		counter1; variable de conteo de mensajes
	
	banksel		PORTC		; Bank containing register PORTC
	clrf		PORTC		; Clears Port C
	clrf		PORTD		; Clears Port D
	clrf 		PORTA
	incf		PORTD
	bsf PORTE,0
	clrf num_msj
	clrf unidades
	clrf decenas
	clrf uni_cod
	clrf dec_cod
	clrf sel
	
;PROGRAMACION DEL TMR0
	;banksel		OPTION_REG  	;Selecciona el Bank1
	;movlw		b'00000111'	;TMR0 como temporizador
	;movwf		OPTION_REG  	;con preescaler de 256 
	BANKSEL	TMR0		;Selecciona el Bank0
	movlw		.217		;Valor decimal 217	
	movwf		TMR0		;Carga el TMR0 con 217
loop
		nop
  	goto	loop		; Permanece en el lazo

binario_a_s_segmentos	; Tabla para display de 7 segmentos.
	addwf	PCL,F	
            ;'-gfedcba'         segmentos
	retlw	b'00111111'			; El código 7 segmentos para el "0".
	retlw	b'00000110'			; El código 7 segmentos para el "1".
	retlw	b'01011011'			; El código 7 segmentos para el "2".
	retlw	b'01001111'			; El código 7 segmentos para el "3".
	retlw	b'01100110'			; El código 7 segmentos para el "4".
	retlw	b'01101101'			; El código 7 segmentos para el "5".
	retlw	b'01111101'			; El código 7 segmentos para el "6".
	retlw	b'00000111'			; El código 7 segmentos para el "7".
	retlw	b'01111111'			; El código 7 segmentos para el "8".
	retlw	b'01100111'			; El código 7 segmentos para el "9".
	retlw	b'01110111'			; El código 7 segmentos para el "A".
	retlw	b'01111100'			; El código 7 segmentos para el "B".
	retlw	b'00111001'			; El código 7 segmentos para el "C".
	retlw	b'01011110'			; El código 7 segmentos para el "D".
	retlw	b'01111001'			; El código 7 segmentos para el "E".
	retlw	b'01110001'			; El código 7 segmentos para el "F".

;************************ INTERRUPT ROUTINE **********************
; Inicio de rutina de interrupción llamado desde org 0x04
;*******************************************************************
encripta_x_16
	movfw PORTC	
	movwf counter2
	bcf STATUS, C
	rlf counter2,1
	bcf STATUS, C
	rlf counter2,1 
	bcf STATUS, C
	rlf counter2,1
	movfw counter2
	return
encripta_x_4
	movfw PORTC	
	movwf counter2
	bcf STATUS, C
	rlf counter2,1
	bcf STATUS, C
	rlf counter2,1 
	movfw counter2
	return

encripta_x_2
	movfw PORTC	
	movwf counter2
	bcf STATUS, C
	rlf counter2,1
	movfw counter2
	return


inter
	;movlw		.20
	;movwf		counter3
	btfss		INTCON,TMR0IF
	goto		externo
		;;;;;;; *****
	movf	sel,w		;Se mueve a si mismo para afectar bandera
	btfss	STATUS,2	;sel=0 refresca dig1; sel=1 refresca dig2
	goto	dig2
dig1	 	
	movf	unidades,w  
	call	binario_a_s_segmentos
	movwf	uni_cod
	movf 	uni_cod,w
	bsf	PORTA,0
	bsf	PORTA,1
	movwf	PORTD
	bcf	PORTA,0
	comf	sel,f
	goto 	dec
dig2	
	movf	decenas,w  
	call		binario_a_s_segmentos
	movwf	dec_cod
	movf 	dec_cod,w
	bsf	PORTA,0
	bsf	PORTA,1
	movwf	PORTD
	bcf	PORTA,1
	comf	sel,f	
	;;;;;
dec
    	
 ; incf		PORTC		; Increments register PORTC by 1
  bcf		INTCON,TMR0IF	; Clears interrupt flag TMR0IF
	movlw 	~.39
   	movwf 	TMR0      		;Repone el TMR0 con ~.39
	goto	Seguir

externo
	movfw   PORTC
	;aqui falta la funcion de encriptacion
	;call encripta_x_4
	;incf num_msj
	;movfw num_msj
	;call binario_a_s_segmentos
	;bsf PORTA,0
	;bcf PORTA,1
	
	;movwf   PORTD
	;;;;;incrementa el numero de mensajes;;;;;;
	INCF 	unidades,f		;Ahora sí 10x100=1000ms=1seg
	movlw	.10
	subwf	unidades,w
	btfss	STATUS,2
	goto	cont
	clrf	unidades
	incf	decenas
	movlw	.10
	subwf	decenas,w
	btfss	STATUS,2
	goto	cont
	clrf	decenas
	;;;;incrementa el numero de mensajes
cont
	bcf		INTCON,INTF 


Seguir
    retfie				; Return from interrupt routine		
;*******************************************************************
; IMPORTANTE: rutina de interrupción termina en retfie
;*******************************************************************
;************************ SUBROUTINES ******************************

;*******************************************************************
       End				; Fin de programa
