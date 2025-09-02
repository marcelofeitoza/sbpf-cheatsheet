.globl entrypoint
entrypoint:
    // -------------------------
    // Syscall Examples
    // -------------------------

    /////////////////////////////////////
    // Example: sol_remaining_compute_units
    // Returns remaining compute units in r0
    // No arguments
    /////////////////////////////////////
    call sol_remaining_compute_units

    /////////////////////////////////////
    // Example: sol_get_stack_height
    // Returns the height of the invocation stack in r0
    // No arguments
    /////////////////////////////////////
    call sol_get_stack_height

    /////////////////////////////////////
    // Example: sol_log_
    // Logs a string message
    // r1 = pointer to message
    // r2 = message length
    /////////////////////////////////////
    lddw r1, sol_log_message       // Load address of the message
    lddw r2, 15                     // Load message length
    call sol_log_                   // Invoke the syscall
    // r0 now contains the syscall result (typically 0 for success)

    /////////////////////////////////////
    // Example: sol_log_64_
    // Logs up to five 64-bit values
    // r1..r5 = 64-bit values to log
    /////////////////////////////////////
    lddw r1, 0x1111111111111111      // Load first 64-bit value
    lddw r2, 0x2222222222222222      // Load second 64-bit value
    lddw r3, 0x3333333333333333      // Load third 64-bit value
    lddw r4, 0x4444444444444444      // Load fourth 64-bit value
    lddw r5, 0x5555555555555555      // Load fifth 64-bit value
    call sol_log_64_                  // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_log_compute_units_
    // Logs remaining compute units
    // No arguments
    /////////////////////////////////////
    call sol_log_compute_units_

    /////////////////////////////////////
    // Example: sol_log_pubkey
    // Logs a 32-byte public key
    // r1 = pointer to 32-byte pubkey
    /////////////////////////////////////
    lddw r1, example_pubkey          // Load address of the public key
    call sol_log_pubkey               // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_log_data
    // Logs arbitrary slices of data
    // r1 = pointer to an array of pointers (to data slices)
    // r2 = number of slices
    /////////////////////////////////////
    // Build one slice {addr,len} on stack at r10-16
    lddw r2, data_slice                // r2 = slice addr
    xor64 r1, r1
    add64 r1, r10                      // r1 = frame pointer
    add64 r1, -16                      // r1 = &slice[0]
    stxdw [r1+0], r2                   // store addr
    lddw r3, 8                         // len = 8 bytes
    stxdw [r1+8], r3                   // store len
    // number of slices = 1
    xor64 r2, r2
    add64 r2, 1
    call sol_log_data                  // Invoke the syscall
    exit                               // Early return to keep test simple

    /////////////////////////////////////
    // Example: sol_create_program_address
    // Calculates a program-derived address (PDA)
    // r1 = pointer to array of seed structures
    // r2 = number of seeds
    // r3 = pointer to program ID
    // r4 = pointer to output buffer for PDA
    /////////////////////////////////////
    lddw r1, seeds_array               // Pointer to seeds array
    lddw r2, 2                         // Number of seeds
    lddw r3, program_id                // Pointer to program ID
    lddw r4, pda_result                // Pointer to PDA output buffer
    call sol_create_program_address     // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_try_find_program_address
    // Calculates a PDA and bump seed
    // r1 = pointer to array of seed structures
    // r2 = number of seeds
    // r3 = pointer to program ID
    // r4 = pointer to output buffer for PDA
    // r5 = pointer to bump seed output (u8)
    /////////////////////////////////////
    lddw r1, seeds_array                 // Pointer to seeds array
    lddw r2, 2                           // Number of seeds
    lddw r3, program_id                  // Pointer to program ID
    lddw r4, pda_result                  // Pointer to PDA output buffer
    lddw r5, bump_seed_ptr               // Pointer to bump seed output
    call sol_try_find_program_address     // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_sha256
    // Calculates SHA-256 hash
    // r1 = vals_addr (pointer to array of &[u8])
    // r2 = vals_len (number of slices)
    // r3 = hash_result_addr (pointer to 32-byte buffer)
    /////////////////////////////////////
    lddw r1, hash_input_slices           // Pointer to input slices array
    lddw r2, 1                           // Number of slices
    lddw r3, hash_output                 // Pointer to hash output buffer
    call sol_sha256                      // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_keccak256
    // Calculates Keccak-256 hash
    // r1 = vals_addr (pointer to array of &[u8])
    // r2 = vals_len (number of slices)
    // r3 = hash_result_addr (pointer to 32-byte buffer)
    /////////////////////////////////////
    lddw r1, hash_input_slices           // Pointer to input slices array
    lddw r2, 1                           // Number of slices
    lddw r3, hash_output                 // Pointer to hash output buffer
    call sol_keccak256                   // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_blake3
    // Calculates BLAKE3 hash
    // r1 = vals_addr (pointer to array of &[u8])
    // r2 = vals_len (number of slices)
    // r3 = hash_result_addr (pointer to 32-byte buffer)
    /////////////////////////////////////
    lddw r1, hash_input_slices           // Pointer to input slices array
    lddw r2, 1                           // Number of slices
    lddw r3, hash_output                 // Pointer to hash output buffer
    call sol_blake3                      // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_secp256k1_recover
    // Recovers a secp256k1 public key from a signed message
    // r1 = hash_addr (pointer to 32-byte hash)
    // r2 = recovery_id (u64)
    // r3 = signature_addr (pointer to 64-byte signature)
    // r4 = result_addr (pointer to 64-byte buffer for recovered pubkey)
    /////////////////////////////////////
    lddw r1, hash_input_data             // Pointer to hash
    lddw r2, 1                           // Recovery ID
    lddw r3, signature                   // Pointer to signature
    lddw r4, secp_pubkey_output          // Pointer to recovered pubkey buffer
    call sol_secp256k1_recover           // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_get_clock_sysvar
    // Writes the clock sysvar to the pointer in r1
    // r1 = pointer to clock sysvar struct
    /////////////////////////////////////
    lddw r1, clock_sysvar_buf           // Pointer to clock sysvar buffer
    call sol_get_clock_sysvar            // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_get_epoch_schedule_sysvar
    // Writes the epoch schedule sysvar to the pointer in r1
    // r1 = pointer to epoch schedule sysvar struct
    /////////////////////////////////////
    lddw r1, epoch_schedule_sysvar_buf   // Pointer to epoch schedule sysvar buffer
    call sol_get_epoch_schedule_sysvar    // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_get_fees_sysvar
    // Writes the fees sysvar to the pointer in r1
    // r1 = pointer to fees sysvar struct
    /////////////////////////////////////
    lddw r1, fees_sysvar_buf             // Pointer to fees sysvar buffer
    call sol_get_fees_sysvar              // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_get_rent_sysvar
    // Writes the rent sysvar to the pointer in r1
    // r1 = pointer to rent sysvar struct
    /////////////////////////////////////
    xor64 r1, r1
    add64 r1, r10
    add64 r1, -96                         // r1 = stack scratch for rent sysvar
    call sol_get_rent_sysvar              // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_get_last_restart_slot
    // Writes the last restart slot to the pointer in r1
    // r1 = pointer to last restart slot buffer
    /////////////////////////////////////
    xor64 r1, r1
    add64 r1, r10
    add64 r1, -104                        // r1 = stack scratch (8 bytes)
    call sol_get_last_restart_slot         // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_memcpy_
    // Copies n bytes from src to dst. Memory areas must NOT overlap.
    // r1 = dst
    // r2 = src
    // r3 = n
    /////////////////////////////////////
    lddw r1, dest_buffer                  // Pointer to destination
    lddw r2, source_buffer                // Pointer to source
    lddw r3, 16                           // Number of bytes to copy
    call sol_memcpy_                       // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_memmove_
    // Copies n bytes from src to dst. Memory areas may overlap.
    // r1 = dst
    // r2 = src
    // r3 = n
    /////////////////////////////////////
    lddw r1, overlapping_dest             // Pointer to destination
    lddw r2, overlapping_src              // Pointer to source
    lddw r3, 16                           // Number of bytes to move
    call sol_memmove_                      // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_memcmp_
    // Compares the first n bytes of s1 and s2.
    // r1 = s1
    // r2 = s2
    // r3 = n
    // r4 = pointer to store result (0 if equal, non-zero otherwise)
    /////////////////////////////////////
    lddw r1, buffer_a                      // Pointer to s1
    lddw r2, buffer_b                      // Pointer to s2
    lddw r3, 16                             // Number of bytes to compare
    xor64 r4, r4
    add64 r4, r10
    add64 r4, -112                         // r4 = stack scratch (4 bytes)
    call sol_memcmp_                        // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_memset_
    // Fills the first n bytes of memory area s with byte c.
    // r1 = s
    // r2 = c
    // r3 = n
    /////////////////////////////////////
    xor64 r1, r1
    add64 r1, r10
    add64 r1, -128                         // r1 = stack scratch (16 bytes)
    lddw r2, 255                          // Byte value to set
    lddw r3, 16                             // Number of bytes to set
    call sol_memset_                        // Invoke the syscall
    exit                                   // Early exit to skip remaining demos

    /////////////////////////////////////
    // Example: sol_invoke_signed_c
    // Executes a cross-program invocation (CPI) with signed seeds (C-style)
    // r1 = instruction_addr
    // r2 = account_infos_addr
    // r3 = account_infos_len
    // r4 = signers_seeds_addr
    // r5 = signers_seeds_len
    /////////////////////////////////////
    lddw r1, cpi_instruction                // Pointer to instruction
    lddw r2, cpi_account_infos              // Pointer to account infos
    lddw r3, 1                              // Number of account infos
    lddw r4, cpi_signers_seeds             // Pointer to signers seeds
    lddw r5, 1                              // Number of signers seeds
    call sol_invoke_signed_c                // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_invoke_signed_rust
    // Executes a cross-program invocation (CPI) with signed seeds (Rust-style)
    // r1 = instruction_addr
    // r2 = account_infos_addr
    // r3 = account_infos_len
    // r4 = signers_seeds_addr
    // r5 = signers_seeds_len
    /////////////////////////////////////
    lddw r1, cpi_instruction                // Pointer to instruction
    lddw r2, cpi_account_infos              // Pointer to account infos
    lddw r3, 1                              // Number of account infos
    lddw r4, cpi_signers_seeds             // Pointer to signers seeds
    lddw r5, 1                              // Number of signers seeds
    call sol_invoke_signed_rust             // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_set_return_data
    // Sets the return data of the current instruction
    // r1 = data_addr
    // r2 = data_len
    /////////////////////////////////////
    // Reuse part of stack region as data; write 10 bytes starting at r10-224
    xor64 r1, r1
    add64 r1, r10
    add64 r1, -224
    lddw r2, 10                             // Length of return data
    call sol_set_return_data                 // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_get_return_data
    // Retrieves the return data of the last CPI
    // r1 = pointer to buffer for return data
    // r2 = buffer length
    // r3 = pointer to program ID buffer
    // Returns actual length in r0
    /////////////////////////////////////
    xor64 r1, r1
    add64 r1, r10
    add64 r1, -160                          // stack buffer for return data (32 bytes)
    lddw r2, 32                             // Buffer length
    xor64 r3, r3
    add64 r3, r10
    add64 r3, -192                          // stack buffer for program id (32 bytes)
    call sol_get_return_data                  // Invoke the syscall
    // r0 now contains the actual length of return data

    /////////////////////////////////////
    // Example: sol_get_processed_sibling_instruction
    // Copies data of a processed sibling Sealevel instruction to memory
    // r1 = instruction index (u64)
    // r2 = pointer to meta struct
    // r3 = pointer to program_id buffer
    // r4 = pointer to data buffer
    // r5 = pointer to accounts buffer
    // Returns 1 if found, 0 otherwise
    /////////////////////////////////////
    mov64 r1, 0                             // Instruction index
    lddw r2, sibling_meta                   // Pointer to meta struct
    lddw r3, sibling_program_id_buf         // Pointer to program_id buffer
    lddw r4, sibling_data_buf               // Pointer to data buffer
    lddw r5, sibling_accounts_buf           // Pointer to accounts buffer
    call sol_get_processed_sibling_instruction  // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_curve_validate_point
    // Validates an elliptic curve point
    // r1 = curve_id (e.g., 1 for alt_bn128)
    // r2 = pointer to point data
    // r3 = pointer to result buffer (0 if valid, 1 otherwise)
    /////////////////////////////////////
    lddw r1, 1                              // curve_id (1 = alt_bn128)
    xor64 r2, r2
    add64 r2, r10
    add64 r2, -256                         // point_data buffer on stack
    lddw r3, curve_validation_result_buf    // Pointer to result buffer
    call sol_curve_validate_point            // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_curve_group_op
    // Performs elliptic curve group operations (add, subtract, multiply)
    // r1 = curve_id (e.g., 1 for alt_bn128)
    // r2 = group_op (e.g., 1 for add, 2 for subtract, 3 for multiply)
    // r3 = pointer to left input point
    // r4 = pointer to right input point
    // r5 = pointer to result point buffer
    // Returns 0 on success, 1 otherwise
    /////////////////////////////////////
    lddw r1, 1                              // curve_id (1 = alt_bn128)
    lddw r2, 1                              // group_op (1 = add)
    lddw r3, left_input_point               // Pointer to left input point
    lddw r4, right_input_point              // Pointer to right input point
    lddw r5, group_op_result_point          // Pointer to result point buffer
    call sol_curve_group_op                  // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_curve_multiscalar_mul
    // Performs elliptic curve multi-scalar multiplication
    // r1 = curve_id (e.g., 1 for alt_bn128)
    // r2 = pointer to scalars array
    // r3 = pointer to points array
    // r4 = number of points
    // r5 = pointer to result point buffer
    // Returns 0 on success, 1 otherwise
    /////////////////////////////////////
    lddw r1, 1                              // curve_id (1 = alt_bn128)
    xor64 r2, r2
    add64 r2, r10
    add64 r2, -288                         // scalars array on stack
    xor64 r3, r3
    add64 r3, r10
    add64 r3, -320                         // points array on stack
    lddw r4, 2                              // Number of points
    lddw r5, multiscalar_mul_result_point   // Pointer to result point buffer
    call sol_curve_multiscalar_mul           // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_curve_pairing_map
    // Performs elliptic curve pairing map
    // r1 = curve_id (e.g., 1 for alt_bn128)
    // r2 = pointer to point data
    // r3 = pointer to result buffer
    // Returns 0 on success, 1 otherwise
    /////////////////////////////////////
    lddw r1, 1                              // curve_id (1 = alt_bn128)
    xor64 r2, r2
    add64 r2, r10
    add64 r2, -352                         // pairing point data on stack
    lddw r3, pairing_result_buf             // Pointer to result buffer
    call sol_curve_pairing_map               // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_alt_bn128_group_op
    // Performs Alt_bn128 group operations (compress, decompress)
    // r1 = group_op (e.g., 1 for compress G1, 2 for decompress G1, etc.)
    // r2 = pointer to input data
    // r3 = input_size (bytes)
    // r4 = pointer to result buffer
    // Returns 0 on success, 1 otherwise
    /////////////////////////////////////
    lddw r1, 1                              // group_op (1 = compress G1)
    lddw r2, alt_bn128_input_data           // Pointer to input data
    lddw r3, 64                             // Input size in bytes
    lddw r4, alt_bn128_compressed_result    // Pointer to result buffer
    call sol_alt_bn128_group_op              // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_big_mod_exp
    // Performs big number modular exponentiation
    // r1 = pointer to BigModExpParams struct
    // r2 = pointer to result buffer
    /////////////////////////////////////
    lddw r1, big_mod_exp_params             // Pointer to BigModExpParams struct
    lddw r2, big_mod_exp_result             // Pointer to result buffer
    call sol_big_mod_exp                    // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_get_epoch_rewards_sysvar
    // Writes EpochRewards to the pointer in r1
    // r1 = pointer to EpochRewards struct
    /////////////////////////////////////
    lddw r1, epoch_rewards_sysvar_buf       // Pointer to EpochRewards struct
    call sol_get_epoch_rewards_sysvar        // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_poseidon
    // Performs Poseidon hashing
    // r1 = parameters
    // r2 = endianness
    // r3 = vals_addr (pointer to data slices)
    // r4 = val_len (number of slices)
    // r5 = hash_result_addr (pointer to hash output)
    /////////////////////////////////////
    lddw r1, poseidon_parameters            // Load Poseidon parameters
    lddw r2, 1                              // Endianness (e.g., 1 for little endian)
    lddw r3, poseidon_input_data            // Pointer to data slices
    lddw r4, 1                              // Number of slices
    lddw r5, poseidon_hash_result           // Pointer to hash output buffer
    call sol_poseidon                       // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_alt_bn128_compression
    // Compresses or decompresses Alt_bn128 points
    // r1 = op (operation code)
    // r2 = pointer to input data
    // r3 = input_size (bytes)
    // r4 = pointer to result buffer
    /////////////////////////////////////
    lddw r1, 1                              // op code (1 = compress G1, 2 = decompress G1, etc.)
    lddw r2, alt_bn128_input_data           // Pointer to input data
    lddw r3, 64                             // Input size in bytes
    lddw r4, alt_bn128_compressed_result    // Pointer to result buffer
    call sol_alt_bn128_compression          // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_curve_group_op (Additional Example)
    // Performs an elliptic curve group operation (e.g., add)
    // r1 = curve_id
    // r2 = group_op (e.g., 1 = add, 2 = subtract, 3 = multiply)
    // r3 = pointer to left input point
    // r4 = pointer to right input point
    // r5 = pointer to result point buffer
    /////////////////////////////////////
    lddw r1, 1                              // curve_id (1 = alt_bn128)
    lddw r2, 1                              // group_op (1 = add)
    lddw r3, left_input_point               // Pointer to left input point
    lddw r4, right_input_point              // Pointer to right input point
    lddw r5, group_op_result_point          // Pointer to result point buffer
    call sol_curve_group_op                  // Invoke the syscall

    /////////////////////////////////////
    // Example: sol_curve_validate_point (Additional Example)
    // Validates an elliptic curve point
    // r1 = curve_id
    // r2 = pointer to point data
    // r3 = pointer to result buffer (0 = valid, 1 = invalid)
    /////////////////////////////////////
    lddw r1, 1                              // curve_id (1 = alt_bn128)
    xor64 r2, r2
    add64 r2, r10
    add64 r2, -384                         // point_data buffer on stack
    lddw r3, curve_validation_result_buf    // Pointer to result buffer
    call sol_curve_validate_point            // Invoke the syscall

    exit

// -------------------------
// Read-only data section
// -------------------------
.rodata
    // -------------------------
    // sol_log_ Message
    // -------------------------
    sol_log_message: .ascii "sol_log_ called"

    // -------------------------
    // sol_log_64_ Values
    // -------------------------
    // No additional data needed as values are loaded directly into r1-r5

    // -------------------------
    // sol_log_pubkey Example
    // -------------------------
    example_pubkey: .ascii "\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1A\x1B\x1C\x1D\x1E\x1F"
        

    // -------------------------
    // sol_log_data Slice
    // -------------------------
    data_slice: .ascii "\xAA\xBB\xCC\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Seeds for PDA
    // -------------------------
    seeds_array: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // Seed 1 structure
    seed1_struct: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00"
        

    // Seed 1 data
    seed1_data: .ascii "\x01\x02\x03\x00\x00\x00\x00\x00"
        

    // Seed 2 structure
    seed2_struct: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00"
        

    // Seed 2 data
    seed2_data: .ascii "\x04\x05\x06\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Program ID
    // -------------------------
    program_id: .ascii "\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01"
        

    // -------------------------
    // PDA Result Buffer
    // -------------------------
    pda_result: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Bump Seed Pointer
    // -------------------------
    bump_seed_ptr: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Hash Input Data
    // -------------------------
    hash_input_data: .ascii "\x01\x02\x03\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Hash Input Slices Array
    // -------------------------
    hash_input_slices: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Hash Output Buffer
    // -------------------------
    hash_output: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Secp256k1 Public Key Output Buffer
    // -------------------------
    secp_pubkey_output: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Group Operation Result Point
    // -------------------------
    group_op_result_point: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Multi-Scalar Multiplication Result Point
    // -------------------------
    multiscalar_mul_result_point: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Pairing Result Buffer
    // -------------------------
    pairing_result_buf: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Curve Validation Result Buffer
    // -------------------------
    curve_validation_result_buf: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Left Input Point for Group Operations
    // -------------------------
    left_input_point: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Right Input Point for Group Operations
    // -------------------------
    right_input_point: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Alt_bn128 Input Data for Compression
    // -------------------------
    alt_bn128_input_data: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Alt_bn128 Compressed Result Buffer
    // -------------------------
    alt_bn128_compressed_result: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // BigModExpParams Structure
    // -------------------------
    big_mod_exp_params: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // BigModExp Base Data
    // -------------------------
    big_mod_exp_base: .ascii "\x01\x02\x03\x00\x00\x00\x00\x00"
        

    // -------------------------
    // BigModExp Exponent Data
    // -------------------------
    big_mod_exp_exponent: .ascii "\x04\x05\x06\x00\x00\x00\x00\x00"
        

    // -------------------------
    // BigModExp Modulus Data
    // -------------------------
    big_mod_exp_modulus: .ascii "\x07\x08\x09\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Epoch Rewards Sysvar Buffer
    // -------------------------
    epoch_rewards_sysvar_buf: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Poseidon Parameters
    // -------------------------
    poseidon_parameters: .ascii "\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Poseidon Input Data
    // -------------------------
    poseidon_input_data: .ascii "\xDE\xAD\xBE\xEF"
        

    // -------------------------
    // Poseidon Hash Result Buffer
    // -------------------------
    poseidon_hash_result: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Signature Data
    // -------------------------
    signature: .ascii "\x11\x22\x33\x44\x55\x66\x77\x88\x99\xAA\xBB\xCC\xDD\xEE\xFF\x00\x11\x22\x33\x44\x55\x66\x77\x88\x99\xAA\xBB\xCC\xDD\xEE\xFF\x00"
        

    // -------------------------
    // Clock Sysvar Buffer
    // -------------------------
    clock_sysvar_buf: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Epoch Schedule Sysvar Buffer
    // -------------------------
    epoch_schedule_sysvar_buf: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Fees Sysvar Buffer
    // -------------------------
    fees_sysvar_buf: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Rent Sysvar Buffer
    // -------------------------
    rent_sysvar_buf: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Last Restart Slot Buffer
    // -------------------------
    last_restart_slot_buf: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Buffer A for memcmp_
    // -------------------------
    buffer_a: .ascii "\xAA\xBB\xCC\xDD\xEE\xFF\x00\x11\x22\x33\x44\x55\x66\x77\x88\x99"
        

    // -------------------------
    // Buffer B for memcmp_
    // -------------------------
    buffer_b: .ascii "\xAA\xBB\xCC\xDD\xEE\xFF\x00\x11\x22\x33\x44\x55\x66\x77\x88\x99"
        

    // -------------------------
    // Memcmp Result Buffer
    // -------------------------
    memcmp_result_buf: .ascii "\x00\x00\x00\x00"
        

    // -------------------------
    // memset_ Buffer
    // -------------------------
    memset_buffer: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Overlapping Source for memmove_
    // -------------------------
    overlapping_src: .ascii "\x11\x22\x33\x44\x55\x66\x77\x88\x99\xAA\xBB\xCC\xDD\xEE\xFF\x00"
        

    // -------------------------
    // Overlapping Destination for memmove_
    // -------------------------
    overlapping_dest: .ascii "\x00\x00\x00\x00"
        

    // -------------------------
    // Source Buffer for sol_memcpy_
    // -------------------------
    source_buffer: .ascii "\xAA\xBB\xCC\xDD\xEE\xFF\x00\x11\x22\x33\x44\x55\x66\x77\x88\x99"
        

    // -------------------------
    // Destination Buffer for sol_memcpy_
    // -------------------------
    dest_buffer: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Sibling Meta Struct
    // -------------------------
    sibling_meta: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Sibling Program ID Buffer
    // -------------------------
    sibling_program_id_buf: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Sibling Data Buffer
    // -------------------------
    sibling_data_buf: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Sibling Accounts Buffer
    // -------------------------
    sibling_accounts_buf: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // CPI Instruction Placeholder
    // -------------------------
    cpi_instruction: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // CPI Account Infos Placeholder
    // -------------------------
    cpi_account_infos: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // CPI Signers Seeds Placeholder
    // -------------------------
    cpi_signers_seeds: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        

    // -------------------------
    // Example Seed Data
    // -------------------------
    some_seed: .ascii "\x12\x34\x56\x00\x00\x00\x00\x00"
        

    // -------------------------
    // BigModExp Result Buffer
    // -------------------------
    big_mod_exp_result: .ascii "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        
