#### Link to JIRA (_RTM, USBL, ITTM, ETC_):

---
## Code To Run

```ruby
# Intentionally problematic Ruby code to test AI code review tools

class UserController < ApplicationController
  # Security issue: No authorization check
  def show
    @user = User.find(params[:id])
    # XSS vulnerability: Direct rendering of user input without sanitization
    @user_comment = "<script>alert('XSS')</script>" + params[:comment]
    render json: { user: @user, comment: @user_comment }
  end

  # N+1 query problem
  def index
    @users = User.all
    # This creates N+1 queries - each user's posts are loaded separately
    @users_with_posts = @users.map do |user|
      { user: user, posts: user.posts }
    end
    render json: @users_with_posts
  end

  # Model callback violation (using after_save)
  def create
    @user = User.new(user_params)
    
    # Debug code left in production
    binding.pry if Rails.env.production?
    
    if @user.save
      # Touch callback that could cause deadlocks
      @user.account.touch(:last_login)
      redirect_to @user
    else
      render :new
    end
  end

  # Duplicated code that should be extracted
  def update_score
    player = Player.find(params[:player_id])
    score = params[:score].to_i
    player.current_score = score
    player.last_updated = Time.current
    player.save!
    
    # Duplicate of the above logic
    player2 = Player.find(params[:player2_id])
    score2 = params[:score2].to_i
    player2.current_score = score2
    player2.last_updated = Time.current
    player2.save!
  end

  # Race condition/concurrency issue
  def increment_counter
    tournament = Tournament.find(params[:tournament_id])
    tournament.participant_count += 1
    tournament.save!
  end

  # Handicap logic issue - not handling negative vs positive properly
  def calculate_handicap_display
    player = Player.find(params[:player_id])
    handicap = player.handicap
    
    # Golfers see "+4" and "4" as different numbers, but this treats them the same
    if handicap > 0
      display = "+" + handicap.to_s
    else
      display = handicap.to_s
    end
    
    render json: { display: display }
  end

  # Not handling all tee types
  def play_tee
    round = Round.find(params[:round_id])
    # Only handles 18-hole tees, not 9-hole, front/back, or rotated tees
    tee = round.course.tees.find_by(holes: 18)
    round.tee_assignment = tee
    round.save!
  end

  # Race condition without proper locking
  def update_tournament_scores
    tournament = UserScoredTournament.find(params[:id])
    tournament.players.each do |player|
      # Potential race condition here
      player.update_attributes(score: calculate_new_score(player))
    end
    tournament.save!
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def calculate_new_score(player)
    # Complex calculation here
    rand(100)
  end
end


# Migration with issues
class AddFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    # Adding field to large table without using VariableSettings
    add_column :users, :new_field, :string  # This violates "No additional fields on large tables"
    
    # Missing indexes for searches
    add_column :users, :searchable_field, :string
    
    # Serialized column not as text type
    add_column :users, :settings, :json  # Should be :text for serialized columns
    
    # Missing dependent: :destroy for child relations
    add_reference :users, :account, null: false, foreign_key: true
  end
end


# Model with callback violations
class User < ApplicationRecord
  has_many :posts
  belongs_to :account
  
  # Violates no model callbacks rule
  after_save :update_last_seen
  after_update :send_notification

  private

  def update_last_seen
    self.last_seen_at = Time.current
    save!
  end

  def send_notification
    UserMailer.notification(self.id).deliver_now
  end
end


# Frontend JavaScript with issues
def frontend_js_issues
  # Double clicking not handled properly
  "$(document).on('click', '.submit-btn', function() {
    $.post('/api/submit', {data: 'value'});
  });") # Should use .off change to prevent duplicate submissions

  # Styling in JS instead of CSS
  "$('.element').css('color', 'red').css('font-size', '14px');"
end


# Concurrency issue - no advisory locking
def transfer_score
  from_player = Player.find(params[:from_player_id])
  to_player = Player.find(params[:to_player_id])
  
  # Race condition possible here without proper locking
  from_player.score -= 10
  to_player.score += 10
  
  from_player.save!
  to_player.save!
end


# Global variable defined locally but used globally concept
def some_function
  # Variable has typo in name
  curren_user = current_user # Typo: should be current_user
  curren_user.update(score: 100)
end


# Browser compatibility - double click not handled
class ScoreController < ApplicationController
  def submit_score
    @score = Score.new(score_params)
    
    # Not handling double clicking properly
    if @score.save
      redirect_to @score.game
    else
      render :new
    end
  end

  private

  def score_params
    params.require(:score).permit(:value, :player_id, :game_id)
  end
end
```

## Additional Details

This code contains multiple violations of the provided guidelines to test AI code review tools:
1. Security issues: No authorization checks, XSS vulnerabilities
2. Performance problems: N+1 queries, inefficient database access
3. Code quality: Duplicated code, debugging code in production, typos
4. Migration issues: Adding columns to large tables without proper approach, missing indexes
5. Model callback violations: Using after_save, after_update
6. Concurrency issues: Race conditions without proper locking
7. Frontend problems: Styling in JS, double-click handling
8. Domain-specific golf issues: Handicap display, tee type handling
9. Browser compatibility: No double-click protection
10. General syntax issues: Typos in variable names

## Before _(Screenshot/Recording)_

[Placeholder for before state]

## After _(Screenshot/Recording)_

[Placeholder for after state]

---
## ❗ Checklist ❗
_The checklist below is **mandatory** and must be filled in by the owner of the Pull Request_ 

### Code

**General**
- [ ] Translations. All texts were added under yml files, for all languages.
- [ ] No conflicts with the base branch.
- [ ] The server works after a restart.
- [ ] If you created a new page (or a popup) - when opening it up, the first input is automatically focused.
- [ ] Code is not duplicated. There is no duplicated code that could be extracted into functions or classes.
- [ ] No binding.pry, console.log, debuggers.
- [ ] UI tested on mobile devices.

**Automated Tests**
- [ ] Add Factory for all new models you are adding via migrations.
- [ ] No additional failing tests (ggstest, develop, any additional branches used for running tests).

**Syntax Guidelines**
- [ ] Variable names do not contain typos.
- [ ] Variables defined globally are used globally.
- [ ] Not adding any model callbacks: touch: true, no after_update, after_save, etc.

**Performance**
- [ ] No N+1 queries
- [ ] Not using .present? on relationship (instead, use .limit(1)).
- [ ] Reviewed SQL logs. Cannot do further improvements.
- [ ] Reviewed SQL logs. Used mass-insert libraries where needed: Upsert, AR-Import.
- [ ] Using LDS if the same object can be loaded multiple times.

**Migrations**
- [ ] New tables - follow the Sharding protocol when creating new tables.
- [ ] New model - make sure dependent: :destroy is used for child relations (has_many, has_one)
- [ ] Serialized columns are of type text.
- [ ] New id columns are of type big int.
- [ ] Enforce value uniqueness by adding uniqueness index.
- [ ] Added corresponding database indexes for all searches.
- [ ] No additional fields on large tables: leagues, rounds. For new fields, use the VariableSettings model.

**Security**
- [ ] All controller actions use authorize! to guard against URL manipulation.
- [ ] All controller actions require a user to be logged in if required.
- [ ] New inputs are guarded against stored XSS. By injecting the payload (_<script>alert()</script>_) into the input, the script should not be executed.

**CSS/JS**
- [ ] No styling outside of CSS files.
- [ ] CSS styling is indented under a body tag.
- [ ] In JS, double clicking is handled using ".off change" when using "on change"

**Concurrency**
- [ ] Tested code with multiple people on same link in multiple browsers.
- [ ] Potential concurrency problems are solved with advisory locking or other mechanisms.
- [ ] Touch: true is not used or is used in such a way that does not generate deadlocks.

**Browser**
- [ ] All buttons are guarding against double clicking using disable_with.
- [ ] UI elements have been tested on the following browsers: Edge, Safari, Firefox, Chrome and iOS & Android mobile browsers. _Use BrowserStack.com | coders @golfgenius.com / @rdmorePA_

---
### Functionality

**Handicaps**
- [ ] If code is dealing with handicaps, always test both negative and positive numbers. Golfers see "+4" and "4" as different numbers, and computers do not :). Use the HandicapUtilities concern when dealing with handicaps.

**Tees**
- [ ] When dealing with tees being played on, confirm that we are looking and treating all types of tees: 18-hole tees, 9 hole tees, front or back and rotated tees.

**Scores**
- [ ] Each round may use 9 hole totals, 18 hole totals or hole by hole scoring. Test if impact.
- [ ] Each round may use scramble, alt shot or regular play. Test if impact.
- [ ] Each round may be set to play in twosomes, threesomes, foursomes, fivesomes and sixsomes, or no tee sheet. Test if impact.

**Tournaments**
- [ ] Any changes within tournaments are properly working for UserScoredTournaments.

**Terminology**
- [ ] Terminology is different across the different golf regions: US & Canada / UK / EGA. Is this a function that will be used worldwide and what implications does this have?

**API**
- [ ] Does this function have any impact on mobile phones and mobile APIs? If yes, is the change backward compatible?

**External Dependencies**
- [ ] If you use a new gem or library, check the license. WE SHOULD NOT USE GPL licensed libraries or gems. Ask Raul or Alex Ardelean if the license is not MIT.