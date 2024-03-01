#################################################################################
#    File : reset.s
#    Author : Alain Greiner
#    Date : 15/12/2011
#################################################################################
#    - It initializes the Status Register (SR) 
#    - It defines the stack size  and initializes the stack pointer ($29) 
#    - It initializes the EPC register, and jumps to user code.
#################################################################################

.section .reset,"ax",@progbits

.extern    seg_stack_base
.extern    seg_data_base

.func    reset
.type    reset,  %function

reset:
.set noreorder

# initializes stack pointer
mfc0  $27,    $15, 1       # Get processor ID
addiu $27,    $27, 1       # Make the index start at 1 instead of 0
li    $28,    0x10000      # Size of procesor's "substack" inside the stack segment
mult  $27,    $28          # Get the substack base address' offset
mflo  $27                  # Retrieve the lower half

la    $29,    seg_stack_base

addu $29,    $29,    $27     # stack size = 16 Kbytes (0x4000)

# initializes SR register
li    $26,    0x0000FF13    
mtc0  $26,    $12            # SR <= 0x0000FF13

# jump to main in user mode
la    $26,    seg_data_base
lw    $26,    0($26)         # get the user code entry point 
mtc0  $26,    $14            # write it in EPC register
eret

.set reorder

.endfunc
.size    reset, .-reset

