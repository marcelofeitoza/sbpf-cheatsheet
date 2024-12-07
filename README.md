# sBPF Cheatsheet

**sBPF Cheatsheet** is a comprehensive reference repository for sBPF (Solana Berkeley Packet Filter) assembly programming. Designed primarily for use with the [`sbpf`](https://github.com/deanmlittle/sbpf) tool, this repository serves as both a learning resource and a practical guide for developers working with sBPF on the Solana blockchain.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Repository Structure](#repository-structure)
- [Running Tests](#running-tests)
- [Usage](#usage)
- [Syscall Reference](#syscall-reference)

## Introduction

sBPF is a subset of the Berkeley Packet Filter (BPF) tailored for the Solana blockchain, enabling the creation of efficient, low-level programs that interact with Solana's runtime. Whether you're developing smart contracts, optimizing performance, or exploring system-level programming on Solana, understanding sBPF assembly is crucial.

This cheatsheet repository provides annotated examples of common sBPF assembly instructions, register usage conventions, control flow mechanisms, and a comprehensive list of syscalls. It's an invaluable resource for both beginners and seasoned developers looking to deepen their understanding of sBPF programming.

## Features

- **Comprehensive Assembly Examples:** Detailed sBPF assembly code snippets covering arithmetic operations, register conventions, control flow, and syscalls.
- **Annotated Code:** Extensive comments and explanations within the assembly files to facilitate learning and reference.
- **Automated Testing:** Rust-based tests to ensure the correctness of assembly programs using the `sbpf` tool.
- **Syscall Reference:** A complete list of sBPF syscalls with descriptions, implemented in `syscalls.s`.
- **Public Repository:** Open for personal reference and community contributions, serving as a collaborative learning tool.

## Prerequisites

Before diving into the sBPF assembly programs, ensure you have the following tools and dependencies installed:

1. **Solana Development Environment:** The Solana tool suite is required for building, deploying, and interacting with Solana programs.

2. **Solana Tool Suite:** Necessary for interacting with the Solana blockchain and deploying programs.

   - Install via [Solana's installation guide](https://docs.solana.com/cli/install-solana-cli-tools):
     ```sh
     sh -c "$(curl -sSfL https://release.solana.com/stable/install)"
     ```

3. **`sbpf` Tool:** The sBPF assembler and linker used to build assembly programs.

   - Install from the [sbpf GitHub repository](https://github.com/deanmlittle/sbpf):
     ```sh
     cargo install --git https://github.com/deanmlittle/sbpf.git
     ```

## Repository Structure

The repository is organized into several key assembly files, each focusing on different aspects of sBPF programming:

# Running Tests

Automated tests ensure that the assembly programs function as expected. The tests are written in Rust and utilize the `sbpf` tool to build and execute the assembly code.

### Test Structure

The Rust test module is located in `src/lib.rs` and includes tests for each assembly program:

```rust
#[cfg(test)]
mod tests {
    use mollusk_svm::{result::Check, Mollusk};
    use solana_sdk::{instruction::Instruction, pubkey::Pubkey};
    use std::path::Path;

    /// Helper function to run a test for a given program.
    ///
    /// # Arguments
    ///
    /// * `program` - The name of the program to test (e.g., "registers", "arithmetic", "control_flow", "syscalls").
    fn run_test(program: &str) {
        let keypair_path = format!("deploy/{}-keypair.json", program);
        assert!(
            Path::new(&keypair_path).exists(),
            "Keypair file does not exist: {}",
            keypair_path
        );

        let program_id_keypair_bytes = std::fs::read(&keypair_path)
            .expect("Failed to read keypair file")
            .get(..32)
            .expect("Keypair file is too short")
            .try_into()
            .expect("Slice with incorrect length");
        let program_id = Pubkey::new_from_array(program_id_keypair_bytes);
        let instruction = Instruction::new_with_bytes(program_id, &[], vec![]);
        let deploy_path = format!("deploy/{}", program);
        assert!(
            Path::new(&(deploy_path.clone() + ".so")).exists(),
            "Deploy path does not exist: {}",
            deploy_path
        );

        let mollusk = Mollusk::new(&program_id, &deploy_path);

        let result =
            mollusk.process_and_validate_instruction(&instruction, &[], &[Check::success()]);

        assert!(
            !result.program_result.is_err(),
            "Program execution failed: {:?}",
            result.program_result
        );
    }

    #[test]
    fn registers() {
        run_test("registers");
    }

    #[test]
    fn arithmetic() {
        run_test("arithmetic");
    }

    #[test]
    fn control_flow() {
        run_test("control_flow");
    }

    #[test]
    fn syscalls() {
        run_test("syscalls");
    }
}
```

### Running the Tests

To build and run the tests, execute the following command in the repository's root directory:

```sh
sbpf build && sbpf test
```

**Expected Output:**

```
❯ sbpf build && sbpf test
🔄 Building "registers"
✅ "registers" built successfully in 21.472ms!
🔄 Building "arithmetic"
✅ "arithmetic" built successfully in 19.219ms!
🔄 Building "control_flow"
✅ "control_flow" built successfully in 17.781ms!
🔄 Building "syscalls"
✅ "syscalls" built successfully in 17.661ms!
🧪 Running tests
   Compiling sbpf-cheatsheet v0.1.0 (/path/to/sbpf-cheatsheet)
    Finished `release` profile [optimized] target(s) in 0.07s
   Compiling sbpf-cheatsheet v0.1.0 (/path/to/sbpf-cheatsheet)
    Finished `test` profile [unoptimized + debuginfo] target(s) in 0.39s
     Running unittests src/lib.rs (target/debug/deps/sbpf_cheatsheet-128e0a5563e8d482)

running 4 tests
... [test logs] ...
test tests::arithmetic ... ok
test tests::registers ... ok
test tests::control_flow ... ok
test tests::syscalls ... ok

test result: ok. 4 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.01s

Doc-tests sbpf_cheatsheet

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s

✅ Tests completed successfully!
```

All tests should pass, indicating that the assembly programs are correctly implemented and function as intended.

## Usage

This repository is intended as a reference for writing and understanding sBPF assembly programs. Here's how you can utilize it:

1. **Clone the Repository:**

   ```sh
   git clone https://github.com/marcelofeitoza/sbpf-cheatsheet.git
   cd sbpf-cheatsheet
   ```

2. **Build the Assembly Programs:**

   Ensure the `sbpf` tool is installed and available in your PATH.

   ```sh
   sbpf build
   ```

   This command compiles all `.s` assembly files in the repository and generates corresponding `.so` shared objects in the `deploy/` directory.

3. **Run Tests:**

   Execute the automated tests to verify the correctness of the assembly programs.

   ```sh
   sbpf test
   ```

4. **Explore the Assembly Files:**

   - **Arithmetic Operations:** `arithmetic.s` demonstrates various arithmetic and bitwise operations.
   - **Register Usage:** `registers.s` explains register conventions and stack operations.
   - **Control Flow:** `control_flow.s` showcases conditional and unconditional jumps based on different comparison types.
   - **Syscalls:** `syscalls.s` provides examples of invoking a wide range of sBPF syscalls.

5. **Reference Syscalls:**

   The `syscalls.s` file includes detailed examples of each syscall, serving as a practical guide for implementing them in your own programs.

## Syscall Reference

The `syscalls.s` file includes implementations of numerous sBPF syscalls. Below is a summarized list of available syscalls with brief descriptions:

- **Logging:**

  - `sol_log_`: Logs a string message.
  - `sol_log_64_`: Logs up to five 64-bit integers.
  - `sol_log_compute_units_`: Logs remaining compute units.
  - `sol_log_pubkey`: Logs a 32-byte public key.
  - `sol_log_data`: Logs arbitrary slices of data.

- **Program Addresses:**

  - `sol_create_program_address`: Calculates a program-derived address (PDA).
  - `sol_try_find_program_address`: Calculates a PDA and bump seed.

- **Hashing:**

  - `sol_sha256`: Calculates SHA-256 hash.
  - `sol_keccak256`: Calculates Keccak-256 hash.
  - `sol_blake3`: Calculates BLAKE3 hash.
  - `sol_poseidon`: Performs Poseidon hashing.

- **Elliptic Curve Operations:**

  - `sol_secp256k1_recover`: Recovers a secp256k1 public key from a signed message.
  - `sol_curve_validate_point`: Validates an elliptic curve point.
  - `sol_curve_group_op`: Performs elliptic curve group operations (add, subtract, multiply).
  - `sol_curve_multiscalar_mul`: Performs elliptic curve multi-scalar multiplication.
  - `sol_curve_pairing_map`: Performs elliptic curve pairing map.
  - `sol_alt_bn128_group_op`: Performs Alt_bn128 group operations (compress, decompress).
  - `sol_alt_bn128_compression`: Compresses or decompresses Alt_bn128 points.

- **Memory Operations:**

  - `sol_memcpy_`: Copies `n` bytes from source to destination (non-overlapping).
  - `sol_memmove_`: Copies `n` bytes from source to destination (may overlap).
  - `sol_memcmp_`: Compares the first `n` bytes of two memory areas.
  - `sol_memset_`: Fills the first `n` bytes of a memory area with a constant byte.

- **Sysvar Access:**

  - `sol_get_clock_sysvar`: Retrieves the clock sysvar.
  - `sol_get_epoch_schedule_sysvar`: Retrieves the epoch schedule sysvar.
  - `sol_get_fees_sysvar`: Retrieves the fees sysvar.
  - `sol_get_rent_sysvar`: Retrieves the rent sysvar.
  - `sol_get_epoch_rewards_sysvar`: Retrieves the epoch rewards sysvar.

- **Cross-Program Invocation (CPI):**

  - `sol_invoke_signed_c`: Executes a CPI with signed seeds (C-style).
  - `sol_invoke_signed_rust`: Executes a CPI with signed seeds (Rust-style).

- **Return Data:**

  - `sol_set_return_data`: Sets the return data of the current instruction.
  - `sol_get_return_data`: Retrieves the return data of the last CPI.

- **Stack Operations:**
  - `sol_remaining_compute_units`: Retrieves remaining compute units.
  - `sol_get_stack_height`: Retrieves the height of the invocation stack.
  - `sol_get_processed_sibling_instruction`: Retrieves data from a processed sibling instruction.

Each syscall example in `syscalls.s` is thoroughly commented to guide you through the necessary register setups and data preparations required for invocation.
