#################################################################################
#	File : reset.s
#	Author : Alain Greiner
#	Date : 25/12/2011
#################################################################################
#       This is a boot code for a mono-processor architecture.
#       - initializes the interrupt vector for DMA and TTY.
#       - initializes the ICU MASK register for DMA and TTY.
#       - initializes the Status Register.
#       - initializes the stack pointer.
#       - initializes the EPC register, and jumps to the user code.
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
	mfc0  $27,    $15,  1       # Get proc_id
	andi  $28,    $27,	0x1		# Processor 1 ?
	bne	  $28,    $0,	proc1


	addiu $27,    $27, 1       # Make the index start at 1 instead of 0
	li    $28,    0x10000      # Size of procesor's "substack" inside the stack segment
	mult  $27,    $28          # Get the substack base address' offset
	mflo  $27                  # Retrieve the lower half of the result

proc0:
	# initialises interrupt vector 
	la	$26,	_interrupt_vector
	la	$27,	_isr_dma
	sw	$27,	0($26)			# _interrupt_vector[0] <= _isr_dma
	la	$27,	_isr_tty_get
	sw	$27,	12($26)			# _interrupt_vector[3] <= _isr_tty_get

	#initializes the ICU MASK[0] register
	la	$26,	seg_icu_base
	addiu	$26,	$26,	0		# ICU[0]
	li  	$27,	0b00001001 		# IRQ_DMA[0] & IRQ_TTY[0]
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
	lw	$26,	0($26)			# $26 <= main[0]
	mtc0	$26,	$14			# write it in EPC register
	eret

proc1:
	# initialises interrupt vector 
	la	$26,	_interrupt_vector
	la	$27,	_isr_dma
	sw	$27,	0($26)			# _interrupt_vector[0] <= _isr_dma
	la	$27,	_isr_tty_get
	sw	$27,	12($26)			# _interrupt_vector[3] <= _isr_tty_get

	#initializes the ICU MASK[0] register
	la	$26,	seg_icu_base
	addiu	$26,	$26,	0		# ICU[0]
	li  	$27,	0b00001001 		# IRQ_DMA[0] & IRQ_TTY[0]
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
	lw	$26,	0($26)			# $26 <= main[0]
	mtc0	$26,	$14			# write it in EPC register
	eret

proc2:
	# initialises interrupt vector 
	la	$26,	_interrupt_vector
	la	$27,	_isr_dma
	sw	$27,	0($26)			# _interrupt_vector[0] <= _isr_dma
	la	$27,	_isr_tty_get
	sw	$27,	12($26)			# _interrupt_vector[3] <= _isr_tty_get

	#initializes the ICU MASK[0] register
	la	$26,	seg_icu_base
	addiu	$26,	$26,	0		# ICU[0]
	li  	$27,	0b00001001 		# IRQ_DMA[0] & IRQ_TTY[0]
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
	lw	$26,	0($26)			# $26 <= main[0]
	mtc0	$26,	$14			# write it in EPC register
	eret

proc3:
	# initialises interrupt vector 
	la	$26,	_interrupt_vector
	la	$27,	_isr_dma
	sw	$27,	0($26)			# _interrupt_vector[0] <= _isr_dma
	la	$27,	_isr_tty_get
	sw	$27,	12($26)			# _interrupt_vector[3] <= _isr_tty_get

	#initializes the ICU MASK[0] register
	la	$26,	seg_icu_base
	addiu	$26,	$26,	0		# ICU[0]
	li  	$27,	0b00001001 		# IRQ_DMA[0] & IRQ_TTY[0]
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
	lw	$26,	0($26)			# $26 <= main[0]
	mtc0	$26,	$14			# write it in EPC register
	eret

	.set reorder
	.endfunc
	.size	reset, .-reset

