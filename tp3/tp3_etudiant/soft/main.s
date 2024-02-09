#################################################################################
#	File : main.s
#	Author : Alain Greiner
#       Date : 15/09/2009
#################################################################################
#       This is a very simple application directly written in MIPS32
#	assembly language, in order to precisely control the memory mapping.
#	The sections names are specific to control the linker.
#################################################################################

# Store this segment of data in the .mydata segment, starting at seg_data_base = 0x0100_0000;
        .section 	.mydata

        .word	main                                            # 1 word = 4 bytes
        .space  124                                             # 124 bytes

# @ 0x0100_0080
A :	.word	  1,  2,  3,  4,  5,  6,  7,  8,  9, 10         # 10 words = 40 bytes
	.word	 11, 12, 13, 14, 15, 16, 17, 18, 19, 20         # 10 words = 40 bytes
	.space 48                                               # 48 bytes

# @ 0x0100_0100
B :	.word	101,102,103,104,105,106,107,108,109,110         # 10 words = 40 bytes
	.word	111,112,113,114,115,116,117,118,119,120         # 10 words = 40 bytes
	.space 48                                               # 48 bytes

# @ 0x0100_0180
C :	.word	  0,  0,  0,  0,  0,  0,  0,  0,  0,  0         # 10 words = 40 bytes
	.word	  0,  0,  0,  0,  0,  0,  0,  0,  0,  0         # 10 words = 40 bytes

# Store this segment of code in the .mycode segment, starting at seg_code_base = 0x0040_0000
        .section 	.mycode

        .set noreorder

# @ 0x0040_0000
main :	
        la   $8, 	A		# $8 <= &A[0] # @ 0x00
        li   $7, 	20	        # $7 <= 20    # @ 0x04
        li   $6, 	0		# $7 <= 0     # @ 0x08

# @ 0x0040_000C
loop :	
        lw   $10, 	0($8)		# $10 <= A[i] # @ 0x0C
        lw   $11, 	128($8)		# $11 <= B[i]
        addi $6, 	$6, 	1	# i <= i+1
        addi $8, 	$8, 	4	# $8 <= &A[i+1]
        add  $12, 	$10, 	$11	# $12 <= A[i]+B[i]
        bne  $6, 	$7, 	loop	# fin de boucle ?
        sw   $12, 	252($8)	        # C[i] <= $12
print:
        la   $4, message
        addi $29,       $29,     -4
        jal  tty_puts
        nop
        addi $29,       $29,     +4
suicide:	
        jal  exit
        nop
message:
        .asciiz   "\n!!! vector sum completed !!!\n"
