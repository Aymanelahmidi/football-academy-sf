Run Apex tests for the Football Academy SF project and report coverage.

Usage:
- `/test` → run all local tests
- `/test FA_ServiceTest` → run a single test class
- `/test FA_ServiceTest,FA_TestDataFactory` → run multiple test classes (comma-separated)

Logic:
- If no argument: `sf apex run test --target-org "FA DEMO" --test-level RunLocalTests --code-coverage --result-format human`
- If one class name: `sf apex run test --target-org "FA DEMO" --class-names $ARG --code-coverage --result-format human`
- If multiple class names (comma-separated): `sf apex run test --target-org "FA DEMO" --class-names $ARG1 --class-names $ARG2 --code-coverage --result-format human`

Report:
1. Pass/Fail per test class
2. Code coverage percentage per class
3. Overall coverage (must be >= 85%)
4. Any failing tests with full error details
5. Classes below 85% coverage that need attention
