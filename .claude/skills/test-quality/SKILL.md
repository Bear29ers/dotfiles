---
name: test-quality
description: Test code quality requirements. Use whenever writing, modifying, or reviewing test code in any project.
---

# Test Code Requirements

## NEVER violate these rules

### Test Quality

- Every test MUST verify actual behavior — never write meaningless assertions like `expect(true).toBe(true)`
- Each test case MUST validate specific inputs and their expected outputs
- Keep mocks to the absolute minimum; tests should reflect real behavior as closely as possible

### No Hardcoding to Make Tests Pass

- NEVER hardcode values in production code just to make a test pass
- NEVER add `if (testMode)` or similar test-only branches in production code
- NEVER embed magic numbers or special test values in production code
- Use environment variables or config files to properly separate test and production environments

### Test Implementation Principles

- Always start from a failing state (Red → Green → Refactor)
- Always test boundary values, abnormal inputs, and error cases
- Prioritize real quality over coverage metrics
- Test case names MUST clearly describe what is being tested

### Before Writing Tests

- Fully understand the feature specification before writing any test
- If anything is unclear, ask the user rather than making assumptions or writing placeholder implementations
