.globl entrypoint
entrypoint:
    // -------------------------
    // Syscall Examples
    // -------------------------

    // /////////////////////////////////////
    // // Example: sol_remaining_compute_units
    // // Returns remaining compute units in r0
    // // No arguments
    // /////////////////////////////////////
    // call sol_remaining_compute_units

    // /////////////////////////////////////
    // // Example: sol_get_stack_height
    // // Returns the height of the invocation stack in r0
    // // No arguments
    // /////////////////////////////////////
    // call sol_get_stack_height

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
    // Load the address of data_slice into r2
    lddw r2, data_slice               // Pointer to data slice

    // Reserve 8 bytes on the stack to store the pointer
    xor64 r1, r1                       // Clear r1
    add64 r1, r10                      // r1 = r10 (frame pointer)
    add64 r1, -8                       // r1 = r10-8 (space for one pointer)
    stxdw [r1+0], r2                   // Store the pointer to data_slice at (r10-8)
    // Set r2 = number_of_slices = 1
    xor64 r2, r2                       // Clear r2
    add64 r2, 1                        // r2 = 1
    call sol_log_data                  // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_create_program_address
    // // Calculates a program-derived address (PDA)
    // // r1 = pointer to array of seed structures
    // // r2 = number of seeds
    // // r3 = pointer to program ID
    // // r4 = pointer to output buffer for PDA
    // /////////////////////////////////////
    // lddw r1, seeds_array               // Pointer to seeds array
    // lddw r2, 2                         // Number of seeds
    // lddw r3, program_id                // Pointer to program ID
    // lddw r4, pda_result                // Pointer to PDA output buffer
    // call sol_create_program_address     // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_try_find_program_address
    // // Calculates a PDA and bump seed
    // // r1 = pointer to array of seed structures
    // // r2 = number of seeds
    // // r3 = pointer to program ID
    // // r4 = pointer to output buffer for PDA
    // // r5 = pointer to bump seed output (u8)
    // /////////////////////////////////////
    // lddw r1, seeds_array                 // Pointer to seeds array
    // lddw r2, 2                           // Number of seeds
    // lddw r3, program_id                  // Pointer to program ID
    // lddw r4, pda_result                  // Pointer to PDA output buffer
    // lddw r5, bump_seed_ptr               // Pointer to bump seed output
    // call sol_try_find_program_address     // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_sha256
    // // Calculates SHA-256 hash
    // // r1 = vals_addr (pointer to array of &[u8])
    // // r2 = vals_len (number of slices)
    // // r3 = hash_result_addr (pointer to 32-byte buffer)
    // /////////////////////////////////////
    // lddw r1, hash_input_slices           // Pointer to input slices array
    // lddw r2, 1                           // Number of slices
    // lddw r3, hash_output                 // Pointer to hash output buffer
    // call sol_sha256                      // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_keccak256
    // // Calculates Keccak-256 hash
    // // r1 = vals_addr (pointer to array of &[u8])
    // // r2 = vals_len (number of slices)
    // // r3 = hash_result_addr (pointer to 32-byte buffer)
    // /////////////////////////////////////
    // lddw r1, hash_input_slices           // Pointer to input slices array
    // lddw r2, 1                           // Number of slices
    // lddw r3, hash_output                 // Pointer to hash output buffer
    // call sol_keccak256                   // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_blake3
    // // Calculates BLAKE3 hash
    // // r1 = vals_addr (pointer to array of &[u8])
    // // r2 = vals_len (number of slices)
    // // r3 = hash_result_addr (pointer to 32-byte buffer)
    // /////////////////////////////////////
    // lddw r1, hash_input_slices           // Pointer to input slices array
    // lddw r2, 1                           // Number of slices
    // lddw r3, hash_output                 // Pointer to hash output buffer
    // call sol_blake3                      // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_secp256k1_recover
    // // Recovers a secp256k1 public key from a signed message
    // // r1 = hash_addr (pointer to 32-byte hash)
    // // r2 = recovery_id (u64)
    // // r3 = signature_addr (pointer to 64-byte signature)
    // // r4 = result_addr (pointer to 64-byte buffer for recovered pubkey)
    // /////////////////////////////////////
    // lddw r1, hash_input_data             // Pointer to hash
    // lddw r2, 1                           // Recovery ID
    // lddw r3, signature                   // Pointer to signature
    // lddw r4, secp_pubkey_output          // Pointer to recovered pubkey buffer
    // call sol_secp256k1_recover           // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_get_clock_sysvar
    // // Writes the clock sysvar to the pointer in r1
    // // r1 = pointer to clock sysvar struct
    // /////////////////////////////////////
    // lddw r1, clock_sysvar_buf           // Pointer to clock sysvar buffer
    // call sol_get_clock_sysvar            // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_get_epoch_schedule_sysvar
    // // Writes the epoch schedule sysvar to the pointer in r1
    // // r1 = pointer to epoch schedule sysvar struct
    // /////////////////////////////////////
    // lddw r1, epoch_schedule_sysvar_buf   // Pointer to epoch schedule sysvar buffer
    // call sol_get_epoch_schedule_sysvar    // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_get_fees_sysvar
    // // Writes the fees sysvar to the pointer in r1
    // // r1 = pointer to fees sysvar struct
    // /////////////////////////////////////
    // lddw r1, fees_sysvar_buf             // Pointer to fees sysvar buffer
    // call sol_get_fees_sysvar              // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_get_rent_sysvar
    // // Writes the rent sysvar to the pointer in r1
    // // r1 = pointer to rent sysvar struct
    // /////////////////////////////////////
    // lddw r1, rent_sysvar_buf             // Pointer to rent sysvar buffer
    // call sol_get_rent_sysvar              // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_get_last_restart_slot
    // // Writes the last restart slot to the pointer in r1
    // // r1 = pointer to last restart slot buffer
    // /////////////////////////////////////
    // lddw r1, last_restart_slot_buf        // Pointer to last restart slot buffer
    // call sol_get_last_restart_slot         // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_memcpy_
    // // Copies n bytes from src to dst. Memory areas must NOT overlap.
    // // r1 = dst
    // // r2 = src
    // // r3 = n
    // /////////////////////////////////////
    // lddw r1, dest_buffer                  // Pointer to destination
    // lddw r2, source_buffer                // Pointer to source
    // lddw r3, 16                           // Number of bytes to copy
    // call sol_memcpy_                       // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_memmove_
    // // Copies n bytes from src to dst. Memory areas may overlap.
    // // r1 = dst
    // // r2 = src
    // // r3 = n
    // /////////////////////////////////////
    // lddw r1, overlapping_dest             // Pointer to destination
    // lddw r2, overlapping_src              // Pointer to source
    // lddw r3, 16                           // Number of bytes to move
    // call sol_memmove_                      // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_memcmp_
    // // Compares the first n bytes of s1 and s2.
    // // r1 = s1
    // // r2 = s2
    // // r3 = n
    // // r4 = pointer to store result (0 if equal, non-zero otherwise)
    // /////////////////////////////////////
    // lddw r1, buffer_a                      // Pointer to s1
    // lddw r2, buffer_b                      // Pointer to s2
    // lddw r3, 16                             // Number of bytes to compare
    // lddw r4, memcmp_result_buf             // Pointer to store result
    // call sol_memcmp_                        // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_memset_
    // // Fills the first n bytes of memory area s with byte c.
    // // r1 = s
    // // r2 = c
    // // r3 = n
    // /////////////////////////////////////
    // lddw r1, memset_buffer                 // Pointer to memory area
    // lddw r2, 0xFF                          // Byte value to set
    // lddw r3, 16                             // Number of bytes to set
    // call sol_memset_                        // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_invoke_signed_c
    // // Executes a cross-program invocation (CPI) with signed seeds (C-style)
    // // r1 = instruction_addr
    // // r2 = account_infos_addr
    // // r3 = account_infos_len
    // // r4 = signers_seeds_addr
    // // r5 = signers_seeds_len
    // /////////////////////////////////////
    // lddw r1, cpi_instruction                // Pointer to instruction
    // lddw r2, cpi_account_infos              // Pointer to account infos
    // lddw r3, 1                              // Number of account infos
    // lddw r4, cpi_signers_seeds             // Pointer to signers seeds
    // lddw r5, 1                              // Number of signers seeds
    // call sol_invoke_signed_c                // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_invoke_signed_rust
    // // Executes a cross-program invocation (CPI) with signed seeds (Rust-style)
    // // r1 = instruction_addr
    // // r2 = account_infos_addr
    // // r3 = account_infos_len
    // // r4 = signers_seeds_addr
    // // r5 = signers_seeds_len
    // /////////////////////////////////////
    // lddw r1, cpi_instruction                // Pointer to instruction
    // lddw r2, cpi_account_infos              // Pointer to account infos
    // lddw r3, 1                              // Number of account infos
    // lddw r4, cpi_signers_seeds             // Pointer to signers seeds
    // lddw r5, 1                              // Number of signers seeds
    // call sol_invoke_signed_rust             // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_set_return_data
    // // Sets the return data of the current instruction
    // // r1 = data_addr
    // // r2 = data_len
    // /////////////////////////////////////
    // lddw r1, return_data_buf                // Pointer to return data
    // lddw r2, 10                             // Length of return data
    // call sol_set_return_data                 // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_get_return_data
    // // Retrieves the return data of the last CPI
    // // r1 = pointer to buffer for return data
    // // r2 = buffer length
    // // r3 = pointer to program ID buffer
    // // Returns actual length in r0
    // /////////////////////////////////////
    // lddw r1, receive_return_data_buf        // Pointer to buffer for return data
    // lddw r2, 32                             // Buffer length
    // lddw r3, return_data_program_id_buf     // Pointer to program ID buffer
    // call sol_get_return_data                  // Invoke the syscall
    // // r0 now contains the actual length of return data

    // /////////////////////////////////////
    // // Example: sol_get_processed_sibling_instruction
    // // Copies data of a processed sibling Sealevel instruction to memory
    // // r1 = instruction index (u64)
    // // r2 = pointer to meta struct
    // // r3 = pointer to program_id buffer
    // // r4 = pointer to data buffer
    // // r5 = pointer to accounts buffer
    // // Returns 1 if found, 0 otherwise
    // /////////////////////////////////////
    // mov64 r1, 0                             // Instruction index
    // lddw r2, sibling_meta                   // Pointer to meta struct
    // lddw r3, sibling_program_id_buf         // Pointer to program_id buffer
    // lddw r4, sibling_data_buf               // Pointer to data buffer
    // lddw r5, sibling_accounts_buf           // Pointer to accounts buffer
    // call sol_get_processed_sibling_instruction  // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_curve_validate_point
    // // Validates an elliptic curve point
    // // r1 = curve_id (e.g., 1 for alt_bn128)
    // // r2 = pointer to point data
    // // r3 = pointer to result buffer (0 if valid, 1 otherwise)
    // /////////////////////////////////////
    // lddw r1, 1                              // curve_id (1 = alt_bn128)
    // lddw r2, point_data                     // Pointer to point data
    // lddw r3, curve_validation_result_buf    // Pointer to result buffer
    // call sol_curve_validate_point            // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_curve_group_op
    // // Performs elliptic curve group operations (add, subtract, multiply)
    // // r1 = curve_id (e.g., 1 for alt_bn128)
    // // r2 = group_op (e.g., 1 for add, 2 for subtract, 3 for multiply)
    // // r3 = pointer to left input point
    // // r4 = pointer to right input point
    // // r5 = pointer to result point buffer
    // // Returns 0 on success, 1 otherwise
    // /////////////////////////////////////
    // lddw r1, 1                              // curve_id (1 = alt_bn128)
    // lddw r2, 1                              // group_op (1 = add)
    // lddw r3, left_input_point               // Pointer to left input point
    // lddw r4, right_input_point              // Pointer to right input point
    // lddw r5, group_op_result_point          // Pointer to result point buffer
    // call sol_curve_group_op                  // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_curve_multiscalar_mul
    // // Performs elliptic curve multi-scalar multiplication
    // // r1 = curve_id (e.g., 1 for alt_bn128)
    // // r2 = pointer to scalars array
    // // r3 = pointer to points array
    // // r4 = number of points
    // // r5 = pointer to result point buffer
    // // Returns 0 on success, 1 otherwise
    // /////////////////////////////////////
    // lddw r1, 1                              // curve_id (1 = alt_bn128)
    // lddw r2, scalar_array                   // Pointer to scalars array
    // lddw r3, point_array                    // Pointer to points array
    // lddw r4, 2                              // Number of points
    // lddw r5, multiscalar_mul_result_point   // Pointer to result point buffer
    // call sol_curve_multiscalar_mul           // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_curve_pairing_map
    // // Performs elliptic curve pairing map
    // // r1 = curve_id (e.g., 1 for alt_bn128)
    // // r2 = pointer to point data
    // // r3 = pointer to result buffer
    // // Returns 0 on success, 1 otherwise
    // /////////////////////////////////////
    // lddw r1, 1                              // curve_id (1 = alt_bn128)
    // lddw r2, pairing_point_data             // Pointer to point data
    // lddw r3, pairing_result_buf             // Pointer to result buffer
    // call sol_curve_pairing_map               // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_alt_bn128_group_op
    // // Performs Alt_bn128 group operations (compress, decompress)
    // // r1 = group_op (e.g., 1 for compress G1, 2 for decompress G1, etc.)
    // // r2 = pointer to input data
    // // r3 = input_size (bytes)
    // // r4 = pointer to result buffer
    // // Returns 0 on success, 1 otherwise
    // /////////////////////////////////////
    // lddw r1, 1                              // group_op (1 = compress G1)
    // lddw r2, alt_bn128_input_data           // Pointer to input data
    // lddw r3, 64                             // Input size in bytes
    // lddw r4, alt_bn128_compressed_result    // Pointer to result buffer
    // call sol_alt_bn128_group_op              // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_big_mod_exp
    // // Performs big number modular exponentiation
    // // r1 = pointer to BigModExpParams struct
    // // r2 = pointer to result buffer
    // /////////////////////////////////////
    // lddw r1, big_mod_exp_params             // Pointer to BigModExpParams struct
    // lddw r2, big_mod_exp_result             // Pointer to result buffer
    // call sol_big_mod_exp                    // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_get_epoch_rewards_sysvar
    // // Writes EpochRewards to the pointer in r1
    // // r1 = pointer to EpochRewards struct
    // /////////////////////////////////////
    // lddw r1, epoch_rewards_sysvar_buf       // Pointer to EpochRewards struct
    // call sol_get_epoch_rewards_sysvar        // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_poseidon
    // // Performs Poseidon hashing
    // // r1 = parameters
    // // r2 = endianness
    // // r3 = vals_addr (pointer to data slices)
    // // r4 = val_len (number of slices)
    // // r5 = hash_result_addr (pointer to hash output)
    // /////////////////////////////////////
    // lddw r1, poseidon_parameters            // Load Poseidon parameters
    // lddw r2, 1                              // Endianness (e.g., 1 for little endian)
    // lddw r3, poseidon_input_data            // Pointer to data slices
    // lddw r4, 1                              // Number of slices
    // lddw r5, poseidon_hash_result           // Pointer to hash output buffer
    // call sol_poseidon                       // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_alt_bn128_compression
    // // Compresses or decompresses Alt_bn128 points
    // // r1 = op (operation code)
    // // r2 = pointer to input data
    // // r3 = input_size (bytes)
    // // r4 = pointer to result buffer
    // /////////////////////////////////////
    // lddw r1, 1                              // op code (1 = compress G1, 2 = decompress G1, etc.)
    // lddw r2, alt_bn128_input_data           // Pointer to input data
    // lddw r3, 64                             // Input size in bytes
    // lddw r4, alt_bn128_compressed_result    // Pointer to result buffer
    // call sol_alt_bn128_compression          // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_curve_group_op (Additional Example)
    // // Performs an elliptic curve group operation (e.g., add)
    // // r1 = curve_id
    // // r2 = group_op (e.g., 1 = add, 2 = subtract, 3 = multiply)
    // // r3 = pointer to left input point
    // // r4 = pointer to right input point
    // // r5 = pointer to result point buffer
    // /////////////////////////////////////
    // lddw r1, 1                              // curve_id (1 = alt_bn128)
    // lddw r2, 1                              // group_op (1 = add)
    // lddw r3, left_input_point               // Pointer to left input point
    // lddw r4, right_input_point              // Pointer to right input point
    // lddw r5, group_op_result_point          // Pointer to result point buffer
    // call sol_curve_group_op                  // Invoke the syscall

    // /////////////////////////////////////
    // // Example: sol_curve_validate_point (Additional Example)
    // // Validates an elliptic curve point
    // // r1 = curve_id
    // // r2 = pointer to point data
    // // r3 = pointer to result buffer (0 = valid, 1 = invalid)
    // /////////////////////////////////////
    // lddw r1, 1                              // curve_id (1 = alt_bn128)
    // lddw r2, point_data                     // Pointer to point data
    // lddw r3, curve_validation_result_buf    // Pointer to result buffer
    // call sol_curve_validate_point            // Invoke the syscall

    exit

// -------------------------
// Read-only data section
// -------------------------
.rodata
    // -------------------------
    // sol_log_ Message
    // -------------------------
    sol_log_message:
        .ascii "sol_log_ called"
        .balign 8

    // -------------------------
    // sol_log_64_ Values
    // -------------------------
    // No additional data needed as values are loaded directly into r1-r5

    // -------------------------
    // sol_log_pubkey Example
    // -------------------------
    example_pubkey:
        .byte 0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07
        .byte 0x08,0x09,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F
        .byte 0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17
        .byte 0x18,0x19,0x1A,0x1B,0x1C,0x1D,0x1E,0x1F
        .balign 8

    // -------------------------
    // sol_log_data Slice
    // -------------------------
    data_slice:
        .byte 0xAA,0xBB,0xCC
        .space 5          // Pad to 8 bytes
        .balign 8

    // -------------------------
    // Seeds for PDA
    // -------------------------
    seeds_array:
        .quad seed1_struct
        .quad seed2_struct
        .balign 8

    // Seed 1 structure
    seed1_struct:
        .quad seed1_data  // Pointer to seed 1 data
        .quad 3           // Length of seed 1 data (3 bytes)
        .balign 8

    // Seed 1 data
    seed1_data:
        .byte 0x01,0x02,0x03
        .balign 8          // Ensure proper alignment

    // Seed 2 structure
    seed2_struct:
        .quad seed2_data  // Pointer to seed 2 data
        .quad 3           // Length of seed 2 data (3 bytes)
        .balign 8

    // Seed 2 data
    seed2_data:
        .byte 0x04,0x05,0x06
        .balign 8          // Ensure proper alignment

    // -------------------------
    // Program ID
    // -------------------------
    program_id:
        .byte 0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01
        .balign 8

    // -------------------------
    // PDA Result Buffer
    // -------------------------
    pda_result:
        .space 32
        .balign 8

    // -------------------------
    // Bump Seed Pointer
    // -------------------------
    bump_seed_ptr:
        .byte 0x00
        .space 7          // Pad to 8 bytes
        .balign 8

    // -------------------------
    // Hash Input Data
    // -------------------------
    hash_input_data:
        .byte 0x01,0x02,0x03
        .space 5          // Pad to 8 bytes
        .balign 8

    // -------------------------
    // Hash Input Slices Array
    // -------------------------
    hash_input_slices:
        .quad hash_input_data
        .balign 8

    // -------------------------
    // Hash Output Buffer
    // -------------------------
    hash_output:
        .space 32
        .balign 8

    // -------------------------
    // Secp256k1 Public Key Output Buffer
    // -------------------------
    secp_pubkey_output:
        .space 64
        .balign 8

    // -------------------------
    // Group Operation Result Point
    // -------------------------
    group_op_result_point:
        .space 64
        .balign 8

    // -------------------------
    // Multi-Scalar Multiplication Result Point
    // -------------------------
    multiscalar_mul_result_point:
        .space 64
        .balign 8

    // -------------------------
    // Pairing Result Buffer
    // -------------------------
    pairing_result_buf:
        .space 64
        .balign 8

    // -------------------------
    // Curve Validation Result Buffer
    // -------------------------
    curve_validation_result_buf:
        .space 8
        .balign 8

    // -------------------------
    // Left Input Point for Group Operations
    // -------------------------
    left_input_point:
        .space 32
        .balign 8

    // -------------------------
    // Right Input Point for Group Operations
    // -------------------------
    right_input_point:
        .space 32
        .balign 8

    // -------------------------
    // Alt_bn128 Input Data for Compression
    // -------------------------
    alt_bn128_input_data:
        .space 64
        .balign 8

    // -------------------------
    // Alt_bn128 Compressed Result Buffer
    // -------------------------
    alt_bn128_compressed_result:
        .space 32
        .balign 8

    // -------------------------
    // BigModExpParams Structure
    // -------------------------
    big_mod_exp_params:
        .quad big_mod_exp_base         // base pointer
        .quad 3                        // base_len
        .quad big_mod_exp_exponent     // exponent pointer
        .quad 3                        // exponent_len
        .quad big_mod_exp_modulus      // modulus pointer
        .quad 3                        // modulus_len
        .balign 8

    // -------------------------
    // BigModExp Base Data
    // -------------------------
    big_mod_exp_base:
        .byte 0x01,0x02,0x03
        .space 5          // Pad to 8 bytes
        .balign 8

    // -------------------------
    // BigModExp Exponent Data
    // -------------------------
    big_mod_exp_exponent:
        .byte 0x04,0x05,0x06
        .space 5          // Pad to 8 bytes
        .balign 8

    // -------------------------
    // BigModExp Modulus Data
    // -------------------------
    big_mod_exp_modulus:
        .byte 0x07,0x08,0x09
        .space 5          // Pad to 8 bytes
        .balign 8

    // -------------------------
    // Epoch Rewards Sysvar Buffer
    // -------------------------
    epoch_rewards_sysvar_buf:
        .space 24         // sizeof(EpochRewards) = 3 * u64 = 24 bytes
        .balign 8

    // -------------------------
    // Poseidon Parameters
    // -------------------------
    poseidon_parameters:
        .quad 1            // Example parameter
        .quad 0            // Example endianness

    // -------------------------
    // Poseidon Input Data
    // -------------------------
    poseidon_input_data:
        .byte 0xDE, 0xAD, 0xBE, 0xEF
        .balign 8

    // -------------------------
    // Poseidon Hash Result Buffer
    // -------------------------
    poseidon_hash_result:
        .space 32
        .balign 8

    // -------------------------
    // Signature Data
    // -------------------------
    signature:
        .byte 0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x88,0x99,0xAA,0xBB,0xCC,0xDD,0xEE,0xFF,0x00,0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x88,0x99,0xAA,0xBB,0xCC,0xDD,0xEE,0xFF,0x00
        .balign 8

    // -------------------------
    // Clock Sysvar Buffer
    // -------------------------
    clock_sysvar_buf:
        .space 64         // Size depends on the sysvar structure
        .balign 8

    // -------------------------
    // Epoch Schedule Sysvar Buffer
    // -------------------------
    epoch_schedule_sysvar_buf:
        .space 64         // Size depends on the sysvar structure
        .balign 8

    // -------------------------
    // Fees Sysvar Buffer
    // -------------------------
    fees_sysvar_buf:
        .space 64         // Size depends on the sysvar structure
        .balign 8

    // -------------------------
    // Rent Sysvar Buffer
    // -------------------------
    rent_sysvar_buf:
        .space 64         // Size depends on the sysvar structure
        .balign 8

    // -------------------------
    // Last Restart Slot Buffer
    // -------------------------
    last_restart_slot_buf:
        .space 8          // u64 size
        .balign 8

    // -------------------------
    // Buffer A for memcmp_
    // -------------------------
    buffer_a:
        .byte 0xAA,0xBB,0xCC,0xDD,0xEE,0xFF,0x00,0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x88,0x99
        .balign 8

    // -------------------------
    // Buffer B for memcmp_
    // -------------------------
    buffer_b:
        .byte 0xAA,0xBB,0xCC,0xDD,0xEE,0xFF,0x00,0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x88,0x99
        .balign 8

    // -------------------------
    // Memcmp Result Buffer
    // -------------------------
    memcmp_result_buf:
        .space 4          // i32 size
        .balign 4

    // -------------------------
    // memset_ Buffer
    // -------------------------
    memset_buffer:
        .space 16
        .balign 8

    // -------------------------
    // Overlapping Source for memmove_
    // -------------------------
    overlapping_src:
        .byte 0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x88,0x99,0xAA,0xBB,0xCC,0xDD,0xEE,0xFF,0x00
        .balign 8

    // -------------------------
    // Overlapping Destination for memmove_
    // -------------------------
    overlapping_dest:
        .space 16
        .balign 8

    // -------------------------
    // Source Buffer for sol_memcpy_
    // -------------------------
    source_buffer:
        .byte 0xAA,0xBB,0xCC,0xDD,0xEE,0xFF,0x00,0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x88,0x99
        .balign 8

    // -------------------------
    // Destination Buffer for sol_memcpy_
    // -------------------------
    dest_buffer:
        .space 16
        .balign 8

    // -------------------------
    // Sibling Meta Struct
    // -------------------------
    sibling_meta:
        .space 64         // Size depends on ProcessedSiblingInstruction structure
        .balign 8

    // -------------------------
    // Sibling Program ID Buffer
    // -------------------------
    sibling_program_id_buf:
        .space 32
        .balign 8

    // -------------------------
    // Sibling Data Buffer
    // -------------------------
    sibling_data_buf:
        .space 128
        .balign 8

    // -------------------------
    // Sibling Accounts Buffer
    // -------------------------
    sibling_accounts_buf:
        .space 40         // 34 + 6 padding bytes
        .balign 8

    // -------------------------
    // CPI Instruction Placeholder
    // -------------------------
    cpi_instruction:
        .space 64         // Placeholder for CPI instruction data
        .balign 8

    // -------------------------
    // CPI Account Infos Placeholder
    // -------------------------
    cpi_account_infos:
        .space 64         // Placeholder for CPI account infos
        .balign 8

    // -------------------------
    // CPI Signers Seeds Placeholder
    // -------------------------
    cpi_signers_seeds:
        .space 64         // Placeholder for CPI signers seeds
        .balign 8

    // -------------------------
    // Example Seed Data
    // -------------------------
    some_seed:
        .byte 0x12,0x34,0x56
        .space 5          // Pad to 8 bytes
        .balign 8

    // -------------------------
    // BigModExp Result Buffer
    // -------------------------
    big_mod_exp_result:
        .space 20         // Length equals modulus_len
        .balign 8
