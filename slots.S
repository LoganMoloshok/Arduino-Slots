.file "slots.S"
.data ;

table1:
        ; A1   G1   D1   A2   G2   D2   A3   G3   D3
  .byte  112, 104, 100, 176, 168, 164, 208, 200, 196 ;

.text ;
.global run	; declare run as global so it is visible outside
.global stop_one;
.global stop_two;
.global stop_three;

        ;	Register B (8-13)
.set DDRB, 4	;
.set PORTB, 5	;
.set PINB, 3	;
        ;	Register D (0-7)
.set DDRD, 10	;
.set PORTD,	11	;
.set PIND, 9	;
        ;	Register C (A5-A0)
.set PORTC, 8	;
.set DDRC, 7	;
        ; set variables
.set A, 4
.set D, 3
.set G, 2
.set d1, 7
.set d2, 6
.set d3, 5

run:
  ; set Data Direction Registers to output
  sbi DDRD, 2   ; Arduino pin 2
  sbi DDRD, 3   ; Arduino pin 3
  sbi DDRD, 4   ; Arduino pin 4
  sbi DDRD, 5   ; Arduino pin 5
  sbi DDRD, 6   ; Arduino pin 6
  sbi DDRD, 7   ; Arduino pin 7

  sbi DDRB, 0   ; Arduino pin 8
  sbi DDRB, 1   ; Arduino pin 9
  sbi DDRB, 2   ; Arduino pin 10
  sbi DDRB, 3   ; Arduino pin 11
  sbi DDRB, 4   ; Arduino pin 12
  sbi DDRB, 5   ; Arduino pin 13

  ; Start with only digit 1 on
  cbi PORTD, d1 ; d1 on
  sbi PORTD, d2 ; d2 off
  sbi PORTD, d3 ; d3 off

  ; Clear all used registers
  clr r16 ; Digit 2 -
  clr r17 ; Digit 1
  clr r18 ; math register
  clr r19 ; Digit 3
  clr r21 ; loop counter
  clr r22 ; loop loop counter
  clr r23 ; digit 1 compare
  clr r24 ; digit 2 compare
  clr r25 ; digit 3 compare
  clr r26 ; light delay

  ; Set initial light delay
  sbr r26, 200;

  ; Set starting lights per digit
  ;   Bit #  76543210
  ;          xxxRDGAS (Rotate, D, G, A, Stop)
  sbr r17, 0b00000010 ; set r17 to 2 (binary)
  sbr r16, 0b00000010 ; set r16 to 2 (binary)
  sbr r19, 0b00000010 ; set r19 to 2 (binary)

  ; Set comparison values per digit
  sbr r23, 2 ;
  sbr r24, 4 ;
  sbr r25, 8 ;


main_loop:
  sbrc r17,4; skip light if rotate flag not set
  call loop_one ;

  sbrc r16,4; skip light if rotate flag not set
  call loop_two ;

  sbrc r19,4; skip light if rotate flag not set
  call loop_three ;

  call inc_counters;

  call main_loop  ;

inc_counters:
  inc r21;


; === Digit 1 ===
loop_one:
  cbi PORTD, d1 ; d1 on
  sbi PORTD, d2 ; d2 off
  sbi PORTD, d3 ; d3 off

  sbrc r17, 1   ; if A1
  call light_a  ; light A

  sbrc r17, 2   ; if G1
  call light_g  ; light G

  sbrc r17, 3   ; if D1
  call light_d  ; light D

  sbrs r17, 0; if stop flag is not set
  call rotate_one;

  sbrs r17, 0;
  call wait;

  ret;

stop_one:
  clr r18 ; clear math register
  sbr r18, 0b00000001 ; set "or" mask
  or r17, r18 ; set digit 1 stop flag

  clr r18 ; clear math register
  sbr r18, 0b00010000 ; set "or" mask
  or r16, r18 ; set digit 2 rotate flag

  sbr r26, 150; increase rotation speed
  ret ;

rotate_one:
  ; rotates the lights in digit 1
  clr r18; reset eor register
  sbrc r17, 1 ; if A1 is on
  sbr r18, 0b00000110; set holder to 0110, to toggle A and G

  sbrc r17, 2 ; if G1 is on
  sbr r18, 0b00001100 ; set holder to 1100, to toggle G and D

  sbrc r17, 3 ; if D1 is on
  sbr r18, 0b00001010; set holder to 1010, to toggle D and A

  cpse r22, r23;
  eor r17, r18  ; toggle flags with XOR

  ret;

; === Digit 2 ===
loop_two:
  sbi PORTD, d1 ; d1 on
  cbi PORTD, d2 ; d2 off
  sbi PORTD, d3 ; d3 off

  sbrc r16, 1   ; if A1
  call light_a  ; light A

  sbrc r16, 2   ; if G1
  call light_g  ; light G

  sbrc r16, 3   ; if D1
  call light_d  ; light D

  sbrs r16, 0;
  call rotate_two;

  sbrs r16, 0;
  call wait;

  ret;

stop_two:
  clr r18 ; clear math register
  sbr r18, 0b00000001 ; set or mask to 1 (only stop flag)
  or r16, r18 ; or r16 with r18, setting the digit 2 stop flag to true
  sbr r26, 100; increase rotation speed
  ret;

rotate_two:
  ; rotates the lights in digit 1
  clr r18; reset eor register
  sbrc r16, 1 ; if A1 is on
  sbr r18, 0b00000110; set holder to 0110, to toggle A and G

  sbrc r16, 2 ; if G1 is on
  sbr r18, 0b00001100 ; set holder to 1100, to toggle G and D

  sbrc r16, 3 ; if D1 is on
  sbr r18, 0b00001010; set holder to 1010, to toggle D and A

  cpse r22, r24;
  eor r16, r18  ; toggle flags with XOR

  ret;


; === Digit 3 ===
loop_three:
  sbi PORTD, d1 ; d1 on
  sbi PORTD, d2 ; d2 off
  cbi PORTD, d3 ; d3 off

  sbrc r19, 1   ; if A1
  call light_a  ; light A

  sbrc r19, 2   ; if G1
  call light_g  ; light G

  sbrc r19, 3   ; if D1
  call light_d  ; light D

  sbrs r19, 0;
  call rotate_three;

  sbrs r19, 0;
  call wait;

  ret;

stop_three:
  clr r18 ; clear math register
  sbr r18, 0b00000001 ; set or mask to 1 (only stop flag)
  or r19, r18 ; or r19 with r18, setting the digit 3 stop flag to true
  ret;

rotate_three:
  ; rotates the lights in digit 1
  clr r18; reset eor register
  sbrc r19, 1 ; if A1 is on
  sbr r18, 0b00000110; set holder to 0110, to toggle A and G

  sbrc r19, 2 ; if G1 is on
  sbr r18, 0b00001100 ; set holder to 1100, to toggle G and D

  sbrc r19, 3 ; if D1 is on
  sbr r18, 0b00001010; set holder to 1010, to toggle D and A

  cpse r22, r25;
  eor r19, r18  ; toggle flags with XOR

  ret;


; === Light Controls ===
light_a:
  sbi PORTD, A ; A on
  cbi PORTD, G ; G off
  cbi PORTD, D ; D off
  ret ;

light_g:
  cbi PORTD, A ; A off
  sbi PORTD, G ; G on
  cbi PORTD, D ; D off
  ret ;

light_d:
  cbi PORTD, A ; A off
  cbi PORTD, G ; G off
  sbi PORTD, D ; D on
  ret ;


; === Timers ===
wait:
  mov r20, r26      ; set delay outer loop based on r26
  call delay_n_ms   ; delay for 250 ms
  ret               ;

delay_n_ms:           ; delay for n micro-secs
  ldi r31,3000>>8     ; Load Immediate: inner loop counts down from 3000
  ldi r30,3000 & 255  ; Load Immediate: so we need to store 3000 in 16 bits

delayloop:
  sbiw r30, 1				; Subtract Immediate Word - subtract 1 from register 30
  brne delayloop			; Branch Not Equal - branch if the above line does not equal 0
  subi r20, 1				; Subtract Immediate - subtract 1 register 20
  brne delay_n_ms    ; Branch Not Equal -
  ret							; outer loop is 0 return


end:
  nop;
