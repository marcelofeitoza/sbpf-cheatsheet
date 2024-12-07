.globl entrypoint
entrypoint:
    // -------------------------
    // Registers Reference
    // -------------------------
    // r0: General-purpose register, often used for return values
    // r1-r5: Function argument registers, used to pass arguments to syscalls
    // r6-r9: Callee-saved registers, used to preserve values across function calls
    // r10: Read-only register, typically used as a frame pointer (stack pointer)

    // -------------------------
    // Demonstration of Register Usage and Conventions
    // -------------------------

    // -------------------------
    // Basic Data Movement
    // -------------------------
    lddw r0, 0          // Load immediate value 0 into r0
    lddw r1, 10         // Load immediate value 10 into r1
    lddw r2, 20         // Load immediate value 20 into r2

    // -------------------------
    // Using Callee-Saved Registers (r6-r9)
    // -------------------------
    // Preserving the values of r1 and r2 by storing them in r6 and r7
    mov64 r6, r1        // Move the value from r1 (10) to r6 (r6 = 10)
    mov64 r7, r2        // Move the value from r2 (20) to r7 (r7 = 20)

    // These callee-saved registers (r6 and r7) maintain their values across function calls,
    // ensuring that r1 and r2 can be safely modified without losing their original values.

    // -------------------------
    // Using r10 and the Stack
    // ------------------------- 
    // r10 serves as the frame pointer. Stack operations are performed using negative offsets from r10.
    // Here, we reserve space on the stack to store the values of r6 and r7.

    stxdw [r10-8], r6    // Store the value of r6 (10) at memory address (r10 - 8)
    stxdw [r10-16], r7   // Store the value of r7 (20) at memory address (r10 - 16)

    // -------------------------
    // Retrieving Values from the Stack
    // -------------------------
    ldxdw r4, [r10-8]    // Load the value from memory address (r10 - 8) into r4 (r4 = 10)
    ldxdw r5, [r10-16]   // Load the value from memory address (r10 - 16) into r5 (r5 = 20)

    // -------------------------
    // Preparing Arguments for a Syscall Call (e.g., sol_log_)
    // -------------------------
    // Syscalls often require specific arguments to be loaded into registers r1-r5.
    // For example, sol_log_ expects:
    //   r1: Pointer to the message to log
    //   r2: Length of the message in bytes

    lddw r1, message      // Load the address of the "Registers demonstration" message into r1
    lddw r2, 23           // Load the length of the message (23 bytes) into r2
    call sol_log_         // Call the sol_log_ syscall to log the message

    // After the syscall, r0 may contain a return value indicating success or failure.

    // -------------------------
    // Exit the Program
    // -------------------------
    exit                  // Exit the program

    // -------------------------
    // Read-only Data Section
    // -------------------------
.rodata
    message: .ascii "Registers demonstration"  // Define the message string to be logged
