#################################################################################
#	File : reset.s
#	Author : Alain Greiner
#	Date : 25/12/2011
#################################################################################
#       This is a boot code for a multi-processor architecture.
#       - initializes the interrupt vector for DMA and TTY.
#       - initializes the ICU MASK register for DMA and TTY.
#       - initializes the Status Register.
#       - initializes the stack pointer.
#       - initializes the EPC register, and jumps to the user code.
#
# 		The 4 processors have different stack pointers, different IRQs 
#		but they share the same main code.
#################################################################################
		
	.section .reset,"ax",@progbits

	.extern	seg_stack_base
	.extern	seg_data_base
	.extern	seg_icu_base

	.func	reset
	.type   reset, %function

reset:
	.set noreorder

	# Get processor ID
	mfc0  $27,    $15,  1       	# Get proc_id
	andi  $27,	  $27,	0b11		# no more than 4 processors (0x3)
	ori   $28,    $0,	0x01		# Processor 1 ?
	beq	  $28,    $27,	proc1
	ori   $28,    $0,	0x10		# Processor 2 ?
	beq	  $28,    $27,	proc2
	ori   $28,    $0,	0x11		# Processor 3 ?
	beq	  $28,    $27,	proc3
	nop 							# Delay slot!

	# Calculate the stack pointer for each processor
	# addiu $27,    $27, 1       # Make the procid start at 1 instead of 0
	# li    $28,    0x10000      # Size of procesor's "substack" inside the stack segment
	# mult  $27,    $28          # Get the substack base address' offset
	# mflo  $27                  # Retrieve the lower half of the result

proc0:
	# initialises interrupt vector (DMA and TTY)
	la	$26,	_interrupt_vector
	la	$27,	_isr_dma		# Only processor 0 handles DMA
	sw	$27,	0($26)			# _interrupt_vector[0] <= _isr_dma
	la	$27,	_isr_tty_get
	sw	$27,	12($26)			# _interrupt_vector[3] <= _isr_tty_get
	# top file line 438
	# icu.p_irq_in[3 + 2 * nproc](signal_irq_tty_get[nproc])
	# 3+(2*0) = 3 words = 12 bytes

	#initializes the ICU MASK[0] register
	la	$26,	seg_icu_base
	addiu	$26,	$26,	0		# ICU[0]
	li  	$27,	0b00001001 		# IRQ_DMA[0] & IRQ_TTY[0] (bit 0 and 3)
	sw	$27,	8($26)

	# initializes stack pointer 
	la	$29,	seg_stack_base
	li	$27,	0x40000			# stack size = 256K
	addu	$29,	$29,	$27 # $29 <= seg_stack_base + 64K

	# initializes SR register
	li	$26,	0x0000FF13	
	mtc0	$26,	$12			# SR <= 0x0000FF13

	# jump to main in user mode
	la	$26,	seg_data_base
	lw	$26,	0($26)			# $26 <= main[0] points to the same main
	mtc0	$26,	$14			# write it in EPC register
	eret

proc1:
	# initialises interrupt vector (TTY)
	la	$26,	_interrupt_vector
	# la	$27,	_isr_dma
	# sw	$27,	0($26)			# _interrupt_vector[0] <= _isr_dma
	la	$27,	_isr_tty_get
	sw	$27,	20($26)			# _interrupt_vector[5] <= _isr_tty_get
	# icu.p_irq_in[3 + 2 * nproc](signal_irq_tty_get[nproc])
	# 3+(2*1) = 5 words = 20 bytes

	#initializes the ICU MASK[1] register
	la	$26,	seg_icu_base
	addiu	$26,	$26,	0x20		# ICU[1]
	li  	$27,	0b00100000 		# IRQ_TTY[1] (bit 5)
	sw	$27,	8($26)

	# initializes stack pointer 
	la	$29,	seg_stack_base
	li	$27,	0x80000			# stack size = 256K
	addu	$29,	$29,	$27 # $29 <= seg_stack_base + 512K

	# initializes SR register
	li	$26,	0x0000FF13	
	mtc0	$26,	$12			# SR <= 0x0000FF13

	# jump to main in user mode
	la	$26,	seg_data_base
	lw	$26,	0($26)			# $26 <= main[1] points to the same main
	mtc0	$26,	$14			# write it in EPC register
	eret

proc2:
	# initialises interrupt vector (TTY)
	la	$26,	_interrupt_vector
	# la	$27,	_isr_dma
	# sw	$27,	0($26)			# _interrupt_vector[0] <= _isr_dma
	la	$27,	_isr_tty_get
	sw	$27,	28($26)			# _interrupt_vector[7] <= _isr_tty_get
	# icu.p_irq_in[3 + 2 * nproc](signal_irq_tty_get[nproc])
	# 3+(2*2) = 7 words = 28 bytes

	#initializes the ICU MASK[2] register
	la	$26,	seg_icu_base
	addiu	$26,	$26,	0x40		# ICU[2]
	li  	$27,	0b10000000 		# IRQ_TTY[2] (bit 7)
	sw	$27,	8($26)

	# initializes stack pointer 
	la	$29,	seg_stack_base
	li	$27,	0xC0000			# stack size = 256K
	addu	$29,	$29,	$27 # $29 <= seg_stack_base + 768K

	# initializes SR register
	li	$26,	0x0000FF13	
	mtc0	$26,	$12			# SR <= 0x0000FF13

	# jump to main in user mode
	la	$26,	seg_data_base
	lw	$26,	0($26)			# $26 <= main[2] points to the same main
	mtc0	$26,	$14			# write it in EPC register
	eret

proc3:
	# initialises interrupt vector (TTY)
	la	$26,	_interrupt_vector
	# la	$27,	_isr_dma
	# sw	$27,	0($26)			# _interrupt_vector[0] <= _isr_dma
	la	$27,	_isr_tty_get
	sw	$27,	36($26)			# _interrupt_vector[9] <= _isr_tty_get
	# icu.p_irq_in[3 + 2 * nproc](signal_irq_tty_get[nproc])
	# 3+(2*3) = 9 words = 36 bytes

	#initializes the ICU MASK[3] register
	la	$26,	seg_icu_base
	addiu	$26,	$26,	0x60		# ICU[3]
	li  	$27,	0b1000000000 		# IRQ_TTY[3] (bit 9)
	sw	$27,	8($26)

	# initializes stack pointer 
	la	$29,	seg_stack_base
	li	$27,	0x100000			# stack size = 256K
	addu	$29,	$29,	$27 # $29 <= seg_stack_base + 1024K

	# initializes SR register
	li	$26,	0x0000FF13	
	mtc0	$26,	$12			# SR <= 0x0000FF13

	# jump to main in user mode
	la	$26,	seg_data_base
	lw	$26,	0($26)			# $26 <= main[3] points to the same main
	mtc0	$26,	$14			# write it in EPC register
	eret

	.set reorder
	.endfunc
	.size	reset, .-reset

