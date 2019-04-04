.include "Header.inc"
.include "InitSNES.asm"


.Macro LoadBlockToVRAM

	lda #$80
	sta $2115 			; VRAM address increment register

	ldx #\2
	stx $2116
	lda #:\1
	ldx #\1
	ldy #\3
	jsr LoadVRAM
.endm

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
	InitSNES						; Clear all registers and memory address

	LoadPalette BG_Palette, 0, 4

	LoadBlockToVRAM Tiles, $0000, $0020 

	lda #$80
	sta $2115
	ldx #$0400
	stx $2116
	lda #$01
	sta $2118

	jsr SetupVideo

;  			lda #%00011111      ; load red (0000000000011111) on acumulator (low byte)
;  		    sta $2122			; store from acumulator on low byte of $2122
;    		stz $2122           ; second byte has no data, so we write a 0 (high byte)
;  		    sta $2100           ; Turn on screen, full brightness
;			stz $2122			; Store 0 to memory $2122 (low byte)
;			stz $2122			; Store 0 to the second byte of $2122 (high byte)

Forever:
	jmp Forever

SetupVideo:

	lda #$00
	sta $2105					; Background mode 0

	lda #$04					
	sta $2107					; BG1 Tile map Location
	
	lda #%00000000
	sta $210B

	lda #$01					
	sta $212C					; Enable BG1

	lda #$FF
	sta $210E
	sta $210E

	lda #$0F
	sta $2100

	rts
	
DMAPalette:	
	stx $4302						;store the ldx #\1 (data offset) in the $4302 (DMA source address channel 0)
	sta $4304						;store data bank of lda in $4304 (DMA source address channel 0)
	sty $4305						;store syze data into $4305 (DMA number of bytes to transfer)

	;initialize de DMA
	stz $4300						;store zero on the DMA control register
	lda #$22						;load on acumulator the number 22 to load it on the DMA 43x1 in the format ($21xx)
	sta $4301						;store $2122 (CGRAM) on DMA destination register
	lda #$01						;load 01 on acumulator
	sta $420B						;Start the DMA (with 01 from acumulator)

	rts 								;return

LoadVRAM:
	stx $4302
	sta $4304
	sty $4305

	lda #$01
	sta $4300
	lda #$18
	sta $4301
	lda #$01
	sta $420B

	rts
.ends

.BANK 1 SLOT 0
.ORG 0
.SECTION "CharacterData"

    .INCLUDE "tiles/tiles.inc"

.ENDS