#################################################################################
#	File : reset.s
#	Author : Alain Greiner
#	Date : 25/12/2011
#################################################################################
#       This is an improved boot code for a bi-processor architecture.
#	Depending on the proc_id, each processor
#       - initializes the interrupt vector.
#       - initializes the ICU MASK registers.
#       - initializes the TIMER .
#       - initializes the Status Register.
#       - initializes the stack pointer.
#       - initializes the EPC register, and jumps to the user code.
#################################################################################
		
	.section .reset,"ax",@progbits
        
        .extern seg_timer_base

	.extern	seg_stack_base
	.extern	seg_data_base
        # Interrupt vector
        .extern _interrupt_vector
        # TIM
        .extern seg_timer_base
        .extern _isr_timer
        # ICU 
        .extern seg_icu_base
        # TTY
        .extern seg_tty_base
        .extern _isr_tty_get

	.func	reset
	.type   reset, %function

reset:
       	.set noreorder

# get the processor id
        mfc0	$27,	$15,	1		# get the proc_id
        andi	$27,	$27,	0x1		# no more than 2 processors
        bne	$27,	$0,	proc1

proc0:
        # initialises interrupt vector entries for PROC[0]
        la      $27,    _interrupt_vector
        # Initialize TIMER ISR
        la      $8,    _isr_timer
        sw      $8,    8($27) # Offset = 2 words = 2*4 = 8 (top file line 438)
        # initializes the ICU[0] MASK register
        la      $8,    seg_icu_base
        addiu   $9,    $0, 0x4  # Corresponds to TIMER[0] interrupt (0100)
        sw      $9,    8($28)   # Sets the corresponding bits 
        # Initialize the TTY[0] ISR
        la      $8,     _isr_tty_get
        sw      $8,    12($27)   

        # Initializes TIMER[0] PERIOD and MODE Registers
        la      $26,    seg_timer_base
        # PERIOD Register 
        li      $27,    50000  # Load 50 000 cycles into the period register
        sw      $27,    8($26)
        # MODE Register 
        addiu   $27,    $0, 0x3 # bit 0: 1, bit 1: 1
        sw      $27,    4($26)

        # initializes stack pointer for PROC[0]
	la	$29,	seg_stack_base
        li	$27,	0x10000			# stack size = 64K
	addu	$29,	$29,	$27    		# $29 <= seg_stack_base + 64K

        # initializes SR register for PROC[0]
       	li	$26,	0x0000FF13	
       	mtc0	$26,	$12			# SR <= 0x0000FF13

        # jump to main in user mode: main[0]
	la	$26,	seg_data_base
        lw	$26,	0($26)			# $26 <= main[0]
	mtc0	$26,	$14			# write it in EPC register
	eret

proc1:
        # initialises interrupt vector entries for PROC[0]
        la      $27,    _interrupt_vector
        # Initialize TIMER ISR
        la      $8,    _isr_timer
        sw      $8,    0x10($27) # Offset = 2 words = 2*4 = 8 (top file line 438)
        # initializes the ICU[0] MASK register
        la      $8,    seg_icu_base
        addiu   $9,    $0, 0x10  # Corresponds to TIMER[0] interrupt (0100)
        sw      $9,    0x18($28)   # Sets the corresponding bits 
        # Initialize the TTY[0] ISR
        la      $8,     _isr_tty_get
        sw      $8,    0x14($27)   

        la      $26,    seg_timer_base
        # initializes TIMER[1] PERIOD 
        li      $27,    100000 # 100 000 cycles
        sw      $27,    0x18($26)
        # initializes TIMER[1] MODE 
        addiu   $27,    $27, 0x3 # bit 0: 1, bit 1: 1 (OPTIONAL)
        sw      $27,    0x14($26)

        # initializes stack pointer for PROC[1]
        la	$29,	seg_stack_base
        li	$27,	0x20000			# stack size = 2*64K
	addu	$29,	$29,	$27    		# $29 <= seg_stack_base + 2*64K
        
        # initializes SR register for PROC[1]
        li	$26,	0x0000FF13	
       	mtc0	$26,	$12			# SR <= 0x0000FF13

        # jump to main in user mode: main[1]
        la	$26,	seg_data_base
        lw	$26,	4($26)			# $26 <= main[1]
	mtc0	$26,	$14			# write it in EPC register
	eret

	.set reorder

	.endfunc
	.size	reset, .-reset

