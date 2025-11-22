# AI Code Review Testing Repository

This repository is designed to test and evaluate different AI tools for code review capabilities, particularly in the context of the Golf Genius codebase. It contains intentionally problematic code that violates various coding standards and best practices to test how well different AI tools can identify and address these issues.

## Repository Structure

- `QWEN.md`: Main documentation file containing project information, code review guidelines, and instructions for Qwen Code
- `test_code.rb`: Ruby file with intentional code issues for testing AI tools
- `rubocop_ai_test_cases.rb`: Comprehensive test file with multiple test cases for both RuboCop and AI tools
- `copilot-instruction.md`: Instructions for GitHub Copilot based on the code review guidelines
- `README.md`: This file

## Code Review Guidelines

The repository follows comprehensive code review guidelines which are categorized into:

1. **General Code Quality**: Translations, conflicts, server restarts, input focus, code duplication, debugging code removal, mobile UI testing
2. **Automated Tests**: Factory patterns, test stability
3. **Syntax Guidelines**: Naming conventions, global variables, callbacks
4. **Performance**: N+1 queries, relationship queries, SQL optimization, mass-insert libraries, LDS usage
5. **Migrations**: Sharding protocol, dependent destruction, column types, indexing
6. **Security**: Authorization, authentication, XSS protection
7. **CSS/JS**: Styling separation, click handling
8. **Concurrency**: Locking mechanisms, deadlock prevention
9. **Browser Compatibility**: Double-clicking, cross-browser testing
10. **Functionality**: Handicaps, tees, scores, tournaments, terminology, API compatibility
11. **External Dependencies**: License compliance

## AI Tool Testing Setup

The repository is structured with multiple branches to test different AI tools:

- `main`: Contains the reference problematic code
- `copilot-review`: AI feedback using GitHub Copilot
- `codeium-review`: AI feedback using Codeium
- `codewhisperer-review`: AI feedback using Amazon CodeWhisperer
- `railsguard-review`: AI feedback using RailsGuard
- `claude-review`: AI feedback using Claude Code
- `askcodi-review`: AI feedback using AskCodi
- `refraction-review`: AI feedback using Refraction
- `workik-review`: AI feedback using Workik AI

## Test Files

### `test_code.rb`
Contains intentionally problematic Ruby code that violates multiple guidelines to test AI tools' ability to identify issues.

### `rubocop_ai_test_cases.rb`
Contains comprehensive test cases including:
- RuboCop violations (naming, line length, method length, etc.)
- Performance issues (N+1 queries, inefficient database queries)
- Security vulnerabilities (XSS, authorization, mass assignment)
- Migration problems (sharding, dependencies, indexing)
- Concurrency issues (deadlocks, race conditions)
- Golf-specific functionality issues (handicaps, tees, scoring)

### `copilot-instruction.md`
Provides specific instructions for GitHub Copilot to follow our code review guidelines during reviews.

## How to Use

1. Clone the repository
2. Switch to the branch for the AI tool you want to test
3. Review the problematic code in `test_code.rb` and `rubocop_ai_test_cases.rb`
4. Apply your AI tool's suggestions
5. Compare the results across different AI tools
6. Evaluate which tool best identifies and addresses the issues according to the guidelines

## Evaluation Criteria

When evaluating AI tools, consider:

- How many of the guidelines violations did the tool identify?
- How accurate are the tool's suggestions?
- How well does the tool explain the issues it identifies?
- How appropriate are the suggested fixes?
- How well does the tool handle domain-specific (golf) requirements?

## License

This repository is for testing purposes and follows the same licensing guidelines as the original codebase, avoiding GPL-licensed dependencies.