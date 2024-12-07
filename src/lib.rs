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
