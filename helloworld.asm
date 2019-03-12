; SNES Initialization Tutorial code
; This code is in the public domain.
 
 .include "Header.inc"
 .include "Snes_Init.asm"
 
 ; Needed to satisfy interrupt definition in "Header.inc".
 VBlank:
   RTI
 
 .bank 0
 .section "MainCode"
 
 Start:

        lda #%00011111      ; load red (0000000000011111) on acumulator (low byte)
        sta $2122	
        stz $2122           ; second byte has no data, so we write a 0 (high byte)

        sta $2100           ; Turn on screen, full brightness

				stz $2122						; Store 0 to memory $2122 (low byte)
				stz $2122						; Store 0 to the second byte of $2122 (high byte)

				stz $2100						; Store 0 to turn off the screen
				lda #%11111111			; low byte white
				sta $2122
				lda #%01111111			; high byte white
				sta $2122
				
				sta $2100
	
	

 Forever:
     jmp Start
 
 .ends
