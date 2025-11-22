# Qwen Code Context - Code Review Directory

## Project Overview
This directory serves as a test repository to evaluate different AI tools that review pull requests using AI code. It contains intentionally problematic code for testing tools like CodeRabbit and AI Copilot against established guidelines.

## Purpose
- Test AI code review tools with intentionally problematic code
- Validate AI tools against comprehensive code review guidelines
- Provide examples of common code issues for benchmarking purposes

## Directory Structure
The directory contains test files designed to highlight various code issues:
- `QWEN.md`: This context file containing project information and instructions for Qwen Code
- `test_code.rb`: Ruby file with intentional code issues for testing AI tools
- Other test files may be added as needed for different scenarios

## Working Environment
- OS: Darwin (macOS)
- Date: Saturday, November 22, 2025
- Current directory: `/Users/iliutaadrian/Sites/code_review`

## Testing Guidelines
This repository follows comprehensive code review guidelines including:
- General code quality (translations, conflicts, server restarts, input focus)
- Automated tests (Factory patterns, test stability)
- Syntax guidelines (variable names, global variables, callbacks)
- Performance (N+1 queries, relationship queries, SQL optimization)
- Migrations (sharding, dependencies, column types)
- Security (authorization, XSS protection)
- Frontend (CSS/JS separation, styling, click handling)
- Concurrency (locking, deadlocks)
- Browser compatibility (double-clicking, cross-browser testing)
- Domain-specific rules (golf handicaps, tees, scores, tournaments)

## Usage Notes
- This repository is intentionally created with code issues for AI testing
- Files contain various problems that should be identified by AI review tools
- The checklist format is used to validate AI tools' ability to catch different types of issues