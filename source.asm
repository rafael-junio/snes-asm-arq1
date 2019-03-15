.include "Header.inc"
.include "Snes_Init.asm"
 
.section "TileData"
	.include "tiles\tiles.inc"
.ends

.Macro LoadPalette
			lda #\2							;Needs to understand what the #\2 means
			sta $2121
			lda #:\1
			ldx #\1
			ldy #(3 * 2)
			jsr DMAPalette
.endm

; Needed to satisfy interrupt definition in "Header.inc".
VBlank:
  			RTI
 
.bank 0
.section "MainCode"
Start:

   			lda #%00011111      ; load red (0000000000011111) on acumulator (low byte)
  		    sta $2122			; store from acumulator on low byte of $2122
    		stz $2122           ; second byte has no data, so we write a 0 (high byte)
  		    sta $2100           ; Turn on screen, full brightness
			stz $2122			; Store 0 to memory $2122 (low byte)
			stz $2122			; Store 0 to the second byte of $2122 (high byte)

Forever:
	    	jmp Start

DMAPalette:
			phb								;push data bank register
			php								;push processor status register
			
			stx $4302						;store the ldx #\1 (data offset) in the $4302 (DMA source address channel 0)
			sta $4304						;store data bank of lda in $4304 (DMA source address channel 0)
			sty $4305						;store syze data into $4305 (DMA number of bytes to transfer)

			;initialize de DMA
			stz $4300						;store zero on the DMA control register
			lda #$22						;load on acumulator the number 22 to load it on the DMA 43x1 in the format ($21xx)
			sta $4301						;store $2122 (CGRAM) on DMA destination register
			lda #$01						;load 01 on acumulator
			sta $420B						;Start the DMA (with 01 from acumulator)

			plb 
			plb 

			rts 								;return

.ends
