.globl entrypoint
entrypoint:
    // -------------------------
    // Data Movement Section
    // -------------------------
    lddw r0, 0   // Load immediate value 0 into r0
    lddw r1, 10  // Load immediate value 10 into r1
    lddw r2, 20  // Load immediate value 20 into r2

    // -------------------------
    // Control Flow Instructions (Unsigned Comparisons)
    // -------------------------
    jeq r1, 10, log  // Jump to 'log' if r1 == 10
    jgt r1, 5, log   // Jump to 'log' if r1 > 5 (unsigned comparison)
    jlt r1, 5, log   // Jump to 'log' if r1 < 5 (unsigned comparison)
    jge r1, 10, log  // Jump to 'log' if r1 >= 10 (unsigned comparison)
    jle r1, 10, log  // Jump to 'log' if r1 <= 10 (unsigned comparison)
    jne r1, 10, log  // Jump to 'log' if r1 != 10

    // -------------------------
    // Control Flow Instructions (Signed Comparisons)
    // -------------------------
    jsgt r2, 15, log  // Jump to 'log' if r2 > 15 (signed comparison)
    jsge r2, 20, log  // Jump to 'log' if r2 >= 20 (signed comparison)
    jslt r2, 100, log // Jump to 'log' if r2 < 100 (signed comparison)
    jsle r2, 20, log  // Jump to 'log' if r2 <= 20 (signed comparison)

    // -------------------------
    // Emulating 'jset' (Jump if Bitwise AND Result is Non-zero)
    // -------------------------
    mov64 r3, r2       // Move the value from r2 into r3 (r3 = 20)
    and64 r3, 16       // Perform bitwise AND between r3 and 16 (r3 = r3 & 16)
    jne r3, 0, log     // Jump to 'log' if the result of the AND is not zero

    // -------------------------
    // Unconditional Jump
    // -------------------------
    ja done             // Unconditionally jump to the 'done' label

    // -------------------------
    // Exit the Program
    // -------------------------
    exit                // Exit the program

    // -------------------------
    // Log Label Section
    // -------------------------
log:
    lddw r1, log_message  // Load the address of the "jumped to log" message into r1
    lddw r2, 14           // Load the length of the log message (14 bytes) into r2
    call sol_log_         // Call the sol_log_ syscall to log the message

    // -------------------------
    // Done Label Section
    // -------------------------
done:
    lddw r1, done_message // Load the address of the "Control flow done" message into r1
    lddw r2, 17           // Load the length of the done message (17 bytes) into r2
    call sol_log_         // Call the sol_log_ syscall to log the done message
    exit                  // Exit the program

    // -------------------------
    // Read-only Data Section
    // -------------------------
.rodata
    log_message: .ascii "jumped to log"     // Define the log message string
    done_message: .ascii "Control flow done" // Define the done message string
