# GitHub Copilot Instructions for Golf Genius Code Reviews

This document provides specific instructions for GitHub Copilot to effectively review code in the Golf Genius codebase according to our established guidelines.

## Code Review Guidelines for Copilot

### Code - General
- Verify all texts have been added under yml files for all languages (Translations)
- Ensure no conflicts with the base branch
- Confirm the server works after a restart
- If a new page or popup is created, verify the first input is automatically focused
- Check for code duplication - look for duplicated logic that could be extracted into functions or classes
- Remove any debugging code like binding.pry, console.log, debuggers
- Ensure UI has been tested on mobile devices

### Automated Tests
- Verify a Factory is added for all new models added via migrations
- Ensure no additional failing tests (ggstest, develop, any additional branches)

### Syntax Guidelines
- Check variable names for typos
- Verify variables defined globally are used globally
- Ensure no model callbacks are added: touch: true, no after_update, after_save, etc.

### Performance
- Detect and flag N+1 queries
- Ensure .present? is not used on relationships (use .limit(1) instead)
- Review SQL logs for possible improvements
- Verify mass-insert libraries are used where needed: Upsert, AR-Import
- Confirm LDS (Lazy Data Store) is used if the same object can be loaded multiple times

### Migrations
- Verify new tables follow the Sharding protocol
- Ensure dependent: :destroy is used for child relations (has_many, has_one)
- Check that serialized columns are of type text
- Verify new ID columns are of type big int
- Ensure value uniqueness is enforced with uniqueness indexes
- Add corresponding database indexes for all searches
- For large tables (leagues, rounds), ensure new fields use the VariableSettings model instead of direct column additions

### Security
- Ensure all controller actions use authorize! to guard against URL manipulation
- Verify all controller actions require a user to be logged in if required
- Check that new inputs are guarded against stored XSS by testing with payload: _<script>alert()</script>_

### CSS/JS
- Ensure no styling is outside of CSS files
- Verify CSS styling is indented under a body tag
- In JS, ensure double clicking is handled using ".off change" when using "on change"

### Concurrency
- Test code with multiple users on same link in multiple browsers
- Solve potential concurrency problems with advisory locking or other mechanisms
- Ensure touch: true is not used or used in a way that does not generate deadlocks

### Browser
- Verify all buttons guard against double clicking using disable_with
- Test UI elements on Edge, Safari, Firefox, Chrome and iOS & Android mobile browsers

### Functionality - Handicaps
- When code deals with handicaps, test both negative and positive numbers
- Remember golfers see "+4" and "4" as different numbers, but computers do not
- Use the HandicapUtilities concern when dealing with handicaps

### Functionality - Tees
- When dealing with tees being played on, confirm handling all types: 18-hole tees, 9 hole tees, front or back and rotated tees

### Functionality - Scores
- Each round may use 9 hole totals, 18 hole totals or hole by hole scoring - test impact
- Each round may use scramble, alt shot or regular play - test impact
- Each round may be set to play in twosomes, threesomes, foursomes, fivesomes and sixsomes, or no tee sheet - test impact

### Functionality - Tournaments
- Ensure changes within tournaments properly work for UserScoredTournaments

### Functionality - Terminology
- Consider that terminology differs across golf regions: US & Canada / UK / EGA
- Consider implications if function will be used worldwide

### Functionality - API
- Check if function has impact on mobile phones and mobile APIs
- Ensure changes are backward compatible

### External Dependencies
- If a new gem or library is used, verify the license is not GPL
- GPL-licensed libraries or gems should not be used - MIT license is preferred

## Golf-Specific Considerations

When reviewing code related to golf functionality:
- Pay special attention to handicap calculations and ensure proper handling of positive and negative values
- Verify tee systems work correctly for all supported formats (18-hole, 9-hole, rotated, etc.)
- Ensure scoring systems properly handle different play styles (scramble, alternate shot, etc.)
- Validate tournament structures work correctly across different formats
- Consider regional golf terminology variations

## Rails-Specific Guidelines

- Follow Rails conventions for naming, structure, and patterns
- Use Rails security features properly (strong parameters, authentication, authorization)
- Leverage Rails performance optimizations (eager loading to prevent N+1 queries, proper indexing, etc.)
- Follow Rails testing patterns and ensure adequate test coverage

## Review Output Format

When providing feedback, structure your comments with:
1. The specific rule being violated
2. The severity level (Critical, High, Medium, Low)
3. A clear explanation of why it's an issue
4. Suggested fixes or alternatives
5. Reference to the relevant section of our guidelines