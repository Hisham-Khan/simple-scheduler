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
    // Save registers R4-R7 on the stack - Not autosaved during context switch
    push {r4-r7}

    // Move registers R8-R11 to R0-R3 for storage - push can access only R0-R7 (uses 3 bit encoding)
    mov r0, r8
    mov r1, r9
    mov r2, r10
    mov r3, r11
    // Save registers R0-R3 (R8-R11) on the stack - Not autosaved during context switch
    push {r0-r3}

task_switcher:
    // Restore registers R0-R3 from the stack
    pop {r0-r3}

    // Move registers R0-R3 back to R8-R11
    mov r8, r0
    mov r9, r1
    mov r10, r2
    mov r11, r3

    // Restore registers R4-R7 from the stack
    pop {r4-r7}
    bx lr

// Tasks
// Task 1
.section .text
.p2align 4
.global task1
.type task1, %function
task1:
    nop
    add r0, r0, #1
    b task1

// Task 2
.section .text
.p2align 4
.global task2
.type task2, %function
task2:
    nop
    add r1, r1, #2
    b task2

// Task 3
.section .text
.p2align 4
.global task3
.type task3, %function
task3:
    nop
    add r2, r2, #3
    b task3

// Stacks for tasks - data section
// Stack for Task 1
.data
.align 4
stack_1:
    .word 0x18          // R8
    .word 0x19          // R9
    .word 0x1A          // R10
    .word 0x1B          // R11
    .word 0x14          // R4
    .word 0x15          // R5
    .word 0x16          // R6
    .word 0x17          // R7
    .word 0x10          // R0
    .word 0x11          // R1
    .word 0x12          // R2
    .word 0x13          // R3
    .word 0x1C          // R12
    .word 0x309         // LR
    .word task1         // PC
    .word 0x01000000    // xPSR

.data
.align 4
// Stack for Task 2
stack_2:
    .word 0x28          // R8
    .word 0x29          // R9
    .word 0x2A          // R10
    .word 0x2B          // R11
    .word 0x24          // R4
    .word 0x25          // R5
    .word 0x26          // R6
    .word 0x27          // R7
    .word 0x20          // R0
    .word 0x21          // R1
    .word 0x22          // R2
    .word 0x23          // R3
    .word 0x2C          // R12
    .word 0x309         // LR
    .word task1         // PC
    .word 0x01000000    // xPSR

.data
.align 4
// Stack for Task 3
stack_3:
    .word 0x38          // R8
    .word 0x39          // R9
    .word 0x3A          // R10
    .word 0x3B          // R11
    .word 0x34          // R4
    .word 0x35          // R5
    .word 0x36          // R6
    .word 0x37          // R7
    .word 0x30          // R0
    .word 0x31          // R1
    .word 0x32          // R2
    .word 0x33          // R3
    .word 0x3C          // R12
    .word 0x309         // LR
    .word task1         // PC
    .word 0x01000000    // xPSR
    .zero 100
