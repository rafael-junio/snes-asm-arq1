.include "Header.inc"
.include "InitSNES.asm"
.include "LoadGraphics.asm"


.equ PalletteNum $0000 			; Variable with the pallette starter
.equ hexXPos $0001
.equ hexYPos $0002
.equ xPosBg2 $0003
.equ yPosBg2 $0004

.Macro Stall
	.rept 10
		WAI
	.endr
.endm


.bank 0
.section "MainCode"

Start:
	InitSNES						; Clear all registers and memory address

	rep	#$10
	sep #$20

	stz PalletteNum				; Store 0 on variable
	stz hexXPos
	stz hexYPos
	stz xPosBg2
	stz yPosBg2

	LoadPalette BG_Palette, 0, 16
	LoadPalette BG_Palette, 32, 48

	LoadBlockToVRAM Tiles, $0000, $0040

	lda #$80
	sta $2115					; Set the VRAM Address Increment Mode to after acessing high byte

	ldx #$0437					
	stx $2116					; VRAM Address
	lda #$03
	sta $2118					; VRAM data Write

	
	ldx #$0401					
	stx $2116					; VRAM Address
	lda #$01
	sta $2118					; VRAM data Write


	jsr SetupVideo

	lda #$80
	sta $4200					; Enable NMI-Vblank

Forever:
	Stall

    lda PalletteNum
    clc
    adc #$04
    and #$0C        ; If palette starting color > 28 (00011100), make 0
    sta PalletteNum
	
	ldx #$0401
	stx $2116
	lda PalletteNum
    sta $2119       ; Write to VRAM

	ldx #$0437
	stx $2116
	lda PalletteNum
    sta $2119       ; Write to VRAM

	lda hexXPos
	clc
	sbc #$01
	sta hexXPos

	lda hexXPos					
	sta $210D					; $210D BG1 Horizontal Scroll
	sta $210D

	lda hexYPos
	clc
	sbc #$04
	sta hexYPos

	lda hexYPos					
	sta $210E					; $210E BG1 Vertical Scroll
	sta $210E

	lda xPosBg2
	clc
	adc #$01
	sta xPosBg2

	lda xPosBg2
	sta $210F					; $210F BG2 Horizontal Scroll
	sta $210F

	lda yPosBg2
	clc
	adc #$04
	sta yPosBg2

	lda yPosBg2
	sta $2110					; $2110 BG2 Vertical Scroll
	sta $2110

	jmp Forever



SetupVideo:

	lda #$00
	sta $2105					; Background mode 0

	lda #$04					; in binary 8 bits, 6 for the address of the tile and two for the size (aaaaaass)					
	sta $2107					; BG1 Tile map Location

	lda #$04
	sta $2108					; BG2 Tile map Location
	
	lda #$00
	sta $210B					; Tile location for BG1 and BG2 (22221111)

	lda #$03					
	sta $212C					; Enable BG1 and BG2

	lda #$0F
	sta $2100					; Turn the screen on

	rts

.ends

.BANK 1 SLOT 0
.ORG 0
.SECTION "CharacterData"

	Tiles:
		.DW $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		.DB $7C,$00,$BA,$7C,$82,$7C,$7C,$00
		.DB $10,$00,$D6,$00,$7C,$00,$38,$00
	Tiles2:
		.db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
    	.db $FF, $00, $DB, $00, $DB, $00, $DB, $00, $FF, $00, $7E, $00, $00, $00, $FF, $00

	BG_Palette:
	.db $00, $00, $C5, $4D, $09, $4B, $98, $FF, $0C, $2C, $0D, $FF, $81, $00, $CA, $00
    .db $26, $0D, $60, $11, $64, $09, $41, $58, $E0, $38, $FF, $03, $E0, $5D, $81, $02, 
.ENDS