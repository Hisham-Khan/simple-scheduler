// SysTick configuration registers
// SysTick Control and Status Register
.equ systick_csr,       0xE000E010
// SysTick Reload Value Register
.equ systick_rvr,       0xE000E014
// SysTick Current Value Register
.equ systick_cvr,       0xE000E018
// SysTick Calibration Value Registers
.equ systick_calib,     0xE000E01C

// SysTick timeout value (24 bits set to 1)
.equ timeout,           0x00ffffff

// Vectors Section (for linker)
.section .vectors
vector_table:
    // Initial Stack Pointer
    .word 0x20001000
    // Reset Handler
    .word reset_handler
// SysTick Handler Address
.org 0x3C
    // SysTick Handler
    .word systick_handler
    // Placeholders for other interrupt vectors
    .zero 400

    // Text Section (for linker)
    .section .text
    .align 1
    // Function: Reset Handler
    .type reset_handler, %function
reset_handler:
    // Load 0 into R5 (0 in binary)
    mov r5, #0x0
    // Load address of SysTick Control and Status Register
    ldr r0, = systick_csr
    // Load address of SysTick Reload Value Register
    ldr r1, = systick_rvr
    // Load address of SysTick Current Value Register
    ldr r2, = systick_cvr
    // Load address of SysTick timeout value
    ldr r3, = timeout

    // Program the SysTick timer
    // To the memory in R1 (systick_rvr), store the timeout value (R3 = 0x00ffffff)
    str r3, [r1]
    // Load 0 into R3 (0 in binary)
    mov r3, #0x0
    // To the memory in R2 (systick_cvr), store the current value (R3 = 0x0) to clear it
    str r3, [r2]
    // Load 7 into R3 (111 in binary)
    mov r3, #0x7
    // To the memory in R0 (systick_csr), store the control and status value (R3 = 0x7) to enable the timer with interrupt
    str r3, [r0]

    // Infinite loop to keep the program running
    b .

    // Text Section (for linker)
    .section .text
    .align 1
    // Function: SysTick Handler
    .type systick_handler, %function
systick_handler:
// Increment the counter in R5
    add r5, r5, #0x1
// Breakpoint
break_here:
    bx lr
