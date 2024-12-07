.globl entrypoint
entrypoint:
    // -------------------------
    // Data Movement Section
    // -------------------------
    lddw r1, 0          // Load the immediate value 0 into register r1
    lddw r2, 10         // Load the immediate value 10 into register r2
    lddw r3, 20         // Load the immediate value 20 into register r3

    //////////////////////////////////////////////////////////////////////
    // Arithmetic/Bitwise Instructions Section
    //////////////////////////////////////////////////////////////////////

    // -------------------------
    // 64-bit Register-based Arithmetic Operations
    // -------------------------
    add64 r1, r2        // Add the value in r2 (10) to r1 (0), result in r1 (10)
    sub64 r1, r2        // Subtract the value in r2 (10) from r1 (10), result in r1 (0)
    mul64 r1, r3        // Multiply the value in r1 (0) by r3 (20), result in r1 (0)
    
    // -------------------------
    // Immediate-based Arithmetic Operations
    // -------------------------
    add64 r1, 1         // Add the immediate value 1 to r1 (0), result in r1 (1)
    mul64 r1, 5         // Multiply the value in r1 (1) by immediate 5, result in r1 (5)
    div64 r1, r2        // Divide the value in r1 (5) by r2 (10), integer division, result in r1 (0)
    
    // -------------------------
    // Modulo Operation
    // -------------------------
    add64 r1, 20        // Add the immediate value 20 to r1 (0), result in r1 (20)
    mod64 r1, r3        // Compute r1 (20) modulo r3 (20), result in r1 (0)

    // -------------------------
    // More Immediate-based Arithmetic Operations
    // -------------------------
    add64 r1, 5         // Add the immediate value 5 to r1 (0), result in r1 (5)
    sub64 r1, 2         // Subtract the immediate value 2 from r1 (5), result in r1 (3)
    mul64 r1, 3         // Multiply the value in r1 (3) by immediate 3, result in r1 (9)
    div64 r1, 3         // Divide the value in r1 (9) by immediate 3, integer division, result in r1 (3)
    mod64 r1, 2         // Compute r1 (3) modulo immediate 2, result in r1 (1)

    // -------------------------
    // Bitwise Operations (64-bit)
    // -------------------------
    or64 r2, r3         // Perform bitwise OR between r2 (10) and r3 (20), result in r2 (30)
    lddw r4, 0xF        // Load the immediate value 0xF (15) into register r4
    and64 r2, r4        // Perform bitwise AND between r2 (30) and r4 (15), result in r2 (14)
    xor64 r3, r2        // Perform bitwise XOR between r3 (20) and r2 (14), result in r3 (26)

    // -------------------------
    // Shifting Operations (64-bit)
    // -------------------------
    lddw r4, 1          // Load the immediate value 1 into register r4
    lsh64 r3, r4        // Logical left shift r3 (26) by 1 bit, result in r3 (52)
    rsh64 r3, r4        // Logical right shift r3 (52) by 1 bit, result in r3 (26)
    arsh64 r3, r4       // Arithmetic right shift r3 (26) by 1 bit, preserving sign, result in r3 (13)

    // -------------------------
    // Negation Operation (64-bit)
    // -------------------------
    neg64 r1            // Negate the value in r1 (1), result in r1 (-1)

    // -------------------------
    // Conditional Jump Based on Arithmetic Result
    // -------------------------
    // At this point, r1 has undergone various arithmetic operations and holds the value -1
    // The following jump checks if r1 equals 10; if true, it jumps to the 'log' label
    jeq r1, 10, log      // Jump to 'log' if r1 == 10

    // -------------------------
    // Exit the Program
    // -------------------------
    exit                // Exit the program

    // -------------------------
    // Log Label Section
    // -------------------------
log:
    lddw r1, log_message  // Load the address of the log message into r1
    lddw r2, 26           // Load the length of the log message (26 bytes) into r2
    call sol_log_         // Call the syscall to log the message
    exit                  // Exit the program

    // -------------------------
    // Read-only Data Section
    // -------------------------
.rodata
    log_message: .ascii "Arithmetic reached the log"  // Define the log message string
