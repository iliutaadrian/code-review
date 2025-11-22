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

## Code Review Rules

### Code - General
- [ ] Translations: All texts were added under yml files, for all languages.
- [ ] No conflicts with the base branch.
- [ ] The server works after a restart.
- [ ] If you created a new page (or a popup) - when opening it up, the first input is automatically focused.
- [ ] Code is not duplicated. There is no duplicated code that could be extracted into functions or classes.
- [ ] No binding.pry, console.log, debuggers.
- [ ] UI tested on mobile devices.

### Automated Tests
- [ ] Add Factory for all new models you are adding via migrations.
- [ ] No additional failing tests (ggstest, develop, any additional branches used for running tests).

### Syntax Guidelines
- [ ] Variable names do not contain typos.
- [ ] Variables defined globally are used globally.
- [ ] Not adding any model callbacks: touch: true, no after_update, after_save, etc.

### Performance
- [ ] No N+1 queries
- [ ] Not using .present? on relationship (instead, use .limit(1)).
- [ ] Reviewed SQL logs. Cannot do further improvements.
- [ ] Reviewed SQL logs. Used mass-insert libraries where needed: Upsert, AR-Import.
- [ ] Using LDS if the same object can be loaded multiple times.

### Migrations
- [ ] New tables - follow the Sharding protocol when creating new tables.
- [ ] New model - make sure dependent: :destroy is used for child relations (has_many, has_one)
- [ ] Serialized columns are of type text.
- [ ] New id columns are of type big int.
- [ ] Enforce value uniqueness by adding uniqueness index.
- [ ] Added corresponding database indexes for all searches.
- [ ] No additional fields on large tables: leagues, rounds. For new fields, use the VariableSettings model.

### Security
- [ ] All controller actions use authorize! to guard against URL manipulation.
- [ ] All controller actions require a user to be logged in if required.
- [ ] New inputs are guarded against stored XSS. By injecting the payload (_<script>alert()</script>_) into the input, the script should not be executed.

### CSS/JS
- [ ] No styling outside of CSS files.
- [ ] CSS styling is indented under a body tag.
- [ ] In JS, double clicking is handled using ".off change" when using "on change"

### Concurrency
- [ ] Tested code with multiple people on same link in multiple browsers.
- [ ] Potential concurrency problems are solved with advisory locking or other mechanisms.
- [ ] Touch: true is not used or is used in such a way that does not generate deadlocks.

### Browser
- [ ] All buttons are guarding against double clicking using disable_with.
- [ ] UI elements have been tested on the following browsers: Edge, Safari, Firefox, Chrome and iOS & Android mobile browsers. _Use BrowserStack.com | coders@golfgenius.com / @rdmorePA_

### Functionality - Handicaps
- [ ] If code is dealing with handicaps, always test both negative and positive numbers. Golfers see "+4" and "4" as different numbers, and computers do not :). Use the HandicapUtilities concern when dealing with handicaps.

### Functionality - Tees
- [ ] When dealing with tees being played on, confirm that we are looking and treating all types of tees: 18-hole tees, 9 hole tees, front or back and rotated tees.

### Functionality - Scores
- [ ] Each round may use 9 hole totals, 18 hole totals or hole by hole scoring. Test if impact.
- [ ] Each round may use scramble, alt shot or regular play. Test if impact.
- [ ] Each round may be set to play in twosomes, threesomes, foursomes, fivesomes and sixsomes, or no tee sheet. Test if impact.

### Functionality - Tournaments
- [ ] Any changes within tournaments are properly working for UserScoredTournaments.

### Functionality - Terminology
- [ ] Terminology is different across the different golf regions: US & Canada / UK / EGA. Is this a function that will be used worldwide and what implications does this have?

### Functionality - API
- [ ] Does this function have any impact on mobile phones and mobile APIs? If yes, is the change backward compatible?

### External Dependencies
- [ ] If you use a new gem or library, check the license. WE SHOULD NOT USE GPL licensed libraries or gems. Ask Raul or Alex Ardelean if the license is not MIT.

## AI Tool Testing Setup

This repository is structured to test multiple AI tools, each on a dedicated branch. The purpose is to evaluate how different AI tools handle the same problematic code in `test_code.rb` and how well they identify the issues that match our comprehensive code review rules above.

Current Branches:
- `main`: Contains the reference problematic code in `test_code.rb`
- `copilot-review`: AI feedback using GitHub Copilot
- `codeium-review`: AI feedback using Codeium
- `codewhisperer-review`: AI feedback using Amazon CodeWhisperer
- `railsguard-review`: AI feedback using RailsGuard
- `claude-review`: AI feedback using Claude Code
- `askcodi-review`: AI feedback using AskCodi
- `refraction-review`: AI feedback using Refraction
- `workik-review`: AI feedback using Workik AI

| Tool                        | Key Features                                                                                                                       | Powerful Example                                                                                                                                                                                                                                              | Pricing/Setup                              | Fit for Golf Genius                                                                                         |
| --------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------ | ----------------------------------------------------------------------------------------------------------- |
| **GitHub Copilot**          | AI pair programmer with PR reviews, code suggestions, and chat for explanations. Supports Ruby/Rails natively in VS Code/RubyMine. | **Performance Check**: In a PR adding a tournament scoring endpoint, Copilot flags an N+1 query in `Round.calculate_scores` and suggests: `Round.includes(:scores).find_each {                                                                                | round                                      | ... }` with a 40% query reduction. Ties to your "No N+1 queries" checklist—auto-generates a test to verify. |
| **Codeium**                 | Free IDE plugin for autocompletion, refactoring, and PR comments. Strong Ruby support for legacy code.                             | **Security Audit**: Reviews a new controller action for handicap input, detects missing `authorize!` and injects `<script>alert('XSS')</script>` test payload—suggests `sanitize` + strong params. Matches your "New inputs guarded against stored XSS" item. | Free (enterprise paid); VS Code/JetBrains. | Budget-friendly for small teams; excels at refactoring Rails migrations without callbacks.                  |
| **Amazon CodeWhisperer**    | AWS-integrated AI for code gen/review, with Rails security scans. Filters suggestions by license.                                  | **Migration Compliance**: For a new `leagues` table field, it enforces "No additional fields on large tables—use VariableSettings" by suggesting a polymorphic association, plus adds uniqueness index. Includes SQL log preview showing 2x speedup.          | Free tier; AWS CLI/VS Code.                | Ideal for your sharding protocol; checks gem licenses (no GPL) during reviews.                              |
| **RailsGuard**              | Rails-specific security scanner for PRs/CI, with fix suggestions. Real-time vuln detection.                                        | **Concurrency Fix**: Spots potential deadlock in `after_save` callback for scores; recommends advisory locking via Redis. Tests with multi-browser sim (e.g., two users editing same round)—prevents your "Touch: true deadlocks" issue.                      | $20/month/team; GitHub Actions.            | Tailored for Rails vulns like URL manipulation; lightweight for quick human follow-ups.                     |
| **Claude Code (Anthropic)** | Terminal-based agent for refactoring and reviews; excels at complex Rails codebases.                                               | **Functionality Test**: For tee-handling code, it generates tests for 9/18-hole, rotated tees + scramble play. Flags missing `HandicapUtilities` concern for negative handicaps ("+4" vs "4"). Outputs RSpec suite with 95% coverage.                         | $20/month; CLI/VS Code.                    | Handles your golf-specific logic (e.g., twosomes/foursomes); great for legacy Rails refactoring.            |
| **AskCodi**                 | Multi-language AI for code explanation, tests, and PR diffs. Ruby/Rails focus.                                                     | **Browser Compatibility**: Analyzes JS for double-click guards (`.off('change')`); suggests `disable_with` for buttons. Simulates Edge/Safari/iOS tests, catching mobile UI breaks in tournament pages.                                                       | Free tier; IDE plugin.                     | Aligns with your "UI tested on mobile" + BrowserStack req; encourages learning via explanations.            |
| **Refraction**              | AI for unit tests, docs, and refactors in 30+ langs incl. Ruby. PR-integrated.                                                     | **API Impact**: For a mobile API change, it checks backward compatibility—auto-generates FactoryBot factories for new models and tests UserScoredTournaments integration. Flags non-MIT gems.                                                                 | $15/month; GitHub app.                     | Boosts your "Automated Tests" checklist; ensures external deps (e.g., no GPL) for worldwide functions.      |
| **Workik AI**               | Context-aware Ruby generator for Rails apps, with review/debug workflows.                                                          | **Terminology Check**: Scans for US/UK/EGA golf terms (e.g., "handicap" vs "course rating"); suggests yml translations + tests for global use. Optimizes Capistrano deploys with RSpec automation.                                                            | Free trial; Web/IDE.                       | Perfect for your regional terminology; streamlines CI/CD for small-team deploys.                            |

#### Core Improved Process: AI-First Hybrid Workflow

1. **Pre-Commit: Self + RuboCop (Automated Gate)**
    - Run RuboCop + Brakeman/Bullet locally/on CI for syntax, style, and security basics. Block PRs if fails (your checklist: variable names, no callbacks).
    - **Idea**: Integrate a linter hook in Git—e.g., husky-like for Ruby. This catches 50% of issues solo, per studies.
    - **Encouragement**: Gamify with VS Code badges; share "zero-RuboCop-violations" shoutouts in Slack.
2. **PR Submission: AI Review as Default**
    - Auto-trigger 1-2 AI tools (e.g., CodeRabbit for refactoring + Qodo for compliance) on PR open. They comment inline, covering 80% of your checklist (e.g., N+1 via Codeium, XSS via RailsGuard).
    - Use your template as a GitHub PR form—pre-fill JIRA, checklist.
    - **Idea**: For small teams, limit to 1 AI + 1 human reviewer. Tools like Copilot Chat explain feedback, speeding responses.
    - **Powerful Twist**: AI generates "Before/After" screenshots/recordings automatically (e.g., via Claude Code).
3. **Human Review: Targeted & Rotational**
    - Assign via round-robin (e.g., GitHub CODEOWNERS for modules like tournaments). Focus humans on checklist's "deep" items: concurrency tests, golf specifics (tees/scores), API impacts.
    - Time-box: 24-48 hours max; ping via automated Slack if stalled.
    - **Idea**: Break large features into <200-line PRs (refactor first, then feature)—reduces overload, per SRP. For high-risk (e.g., migrations), add a quick 15-min pair-review call.
    - **Encouragement**: Rotate roles weekly—everyone reviews once/week. Reward with "Review Hero" points toward team lunches; track via simple JIRA dashboard (e.g., avg review time <1 day).
4. **Post-Merge: Validation + Learning**
    - CI runs full tests (RSpec, ggstest) + human spot-checks (e.g., BrowserStack for mobile).
    - **Idea**: Monthly retros: "What AI missed? How to train it?" (E.g., fine-tune Copilot on your Rails patterns). Measure success: Defect rate down 30%, review time halved.
    - **Encouragement**: Share wins—e.g., "AI caught XSS, saving 2 hours!" Build buy-in with a pilot: Test on 5 PRs, demo ROI.

# Recommended Stack for Golf Genius

### For Static Analysis (Pre-AI):

**Rubocop** - Essential, free, catches style + basic security

**Brakeman** - Rails security scanner (catches XSS, SQL injection)

**Bundler Audit** - Dependency vulnerability scanning

### For AI-Powered Review:

**CodeRabbit (Primary)** - Best Rails support, architecture diagrams, refactoring

**DeepSource (Secondary)** - Rails-specific checks, custom rules, good UX

### For Additional Insights:

**SonarQube Community** - Self-hosted, detailed quality metrics

**Codacy** - Dashboard view, team collaboration

### Budget Estimate:

- CodeRabbit: ~$200-400/month (small team)
- DeepSource: ~$100-200/month
- SonarQube: Free (community) or $5-50/month
- **Total: $300-650/month for full suite**

#### Broader Strategies to Encourage Participation

- **Cultural Shift**: Frame reviews as "team investment" not chore—e.g., "Reviewing builds your Rails expertise for golf features." Pair juniors with seniors for mentorship.
- **Tooling Boost**: Free/cheap starts (Codeium + RuboCop) yield quick wins; budget $50/month for premium (Copilot) after pilot.
- **Incentives**: Non-monetary—flex hours post-review, or "knowledge shares" (5-min talks on cool fixes).
- **Scale Smart**: If growth allows, hire a part-time "review lead" or outsource audits quarterly.

