# This is intentionally problematic code for AI code review testing

class Tournament < ActiveRecord::Base
  has_many :rounds
  has_many :players  # Missing dependent: :destroy
  
  # Global variable - bad practice
  $global_counter = 0
  
  # Touch: true - can cause deadlocks
  belongs_to :league, touch: true
  
  # Variable with typo
  def calculate_tournamnt_scores
    $global_counter += 1
    
    # N+1 query problem
    rounds.each do |round|
      puts round.scores.count
    end
    
    # Using .present? on relationship - performance issue
    if players.present?
      puts "Has players"
    end
    
    # Binding.pry for debugging - should be removed
    binding.pry
    
    # Code duplication - should be extracted
    player_names = []
    players.each do |player|
      player_names << player.name
    end
    
    # Another duplicated block
    player_emails = []
    players.each do |player|
      player_emails << player.email
    end
    
    return player_names, player_emails
  end
  
  # Security: Missing authorization
  def update_handicap_safe
    # Potential XSS - not sanitizing input
    params[:handicap_comment] # Should sanitize this
    
    # Touching a large table directly instead of using VariableSettings
    self.update(handicap_notes: params[:notes])  # Should use VariableSettings for large tables
    
    # Not handling negative handicaps properly
    if handicap > 0
      # Missing logic for "+4" vs "4" distinction
      puts "Positive handicap: #{handicap}"
    end
  end
end

class Round < ActiveRecord::Base
  belongs_to :tournament
  
  # Callback - not following guidelines
  after_save :update_tournament_cache, if: :scores_changed?
  
  def update_tournament_cache
    tournament.update_cache
  end
  
  # Performance: Not using mass-insert libraries where needed
  def import_scores(scores_data)
    scores_data.each do |score_data|
      Score.create(score_data)
    end
  end
end

class Score < ActiveRecord::Base
  belongs_to :round
  
  # Serialized column not using text type
  serialize :metadata  # Should be text type
end

# Controller with security issues
class TournamentsController < ApplicationController
  # Missing authorize! - security vulnerability
  def show
    @tournament = Tournament.find(params[:id])
  end
  
  def create
    # Missing login requirement
    @tournament = Tournament.new(tournament_params)
    
    # Not guarding against XSS with user input
    @tournament.notes = params[:notes]
    
    if @tournament.save
      redirect_to @tournament
    else
      render :new
    end
  end
  
  private
  
  def tournament_params
    params.require(:tournament).permit(:name, :notes) # Should not permit notes without sanitization
  end
end

# JavaScript-style issues (in Ruby comments to test review tools)
# In real JS: Double clicking not handled properly
# $('.save-button').on('click', function() { 
#   // Should use .off('click') to prevent multiple submissions
# })

# CSS not properly indented
# div.some-class { color: red; } # Should be under body tag

# Migration with issues
class AddFieldToLargeTable < ActiveRecord::Migration[6.1]
  def change
    # Adding field to large table instead of using VariableSettings
    add_column :tournaments, :new_field, :string  # Should use VariableSettings for large tables
    
    # ID column not specified as big int
    add_column :tournaments, :user_id, :integer   # Should be :bigint
    
    # Missing uniqueness index
    add_column :tournaments, :name, :string
  end
end

# Functionality issues for golf-specific code
class TeeSheet < ActiveRecord::Base
  # Not handling all tee types (18-hole, 9-hole, rotated)
  def calculate_tee_times
    # Only handles 18-hole tees, not 9-hole, front/back, or rotated tees
    groups = players.in_groups_of(4)
    start_time = Time.current
    
    groups.each_with_index do |group, index|
      # Missing logic for different scoring types (scramble, alt shot)
      # Missing logic for different play formats (twosomes, threesomes, etc.)
      puts "Group #{index + 1}: #{group.map(&:name).join(', ')} at #{start_time + (index * 10).minutes}"
    end
  end
end

# API compatibility not considered
class Api::V1::TournamentsController < ApplicationController
  def update
    @tournament = Tournament.find(params[:id])
    
    # Not considering backward compatibility for mobile APIs
    @tournament.update!(tournament_params)
    
    render json: @tournament # Could break mobile clients if schema changes
  end
end

# External dependency license not checked
# gem 'some_gem', '~> 1.0' # Could be GPL licensed - violates guidelines

# Missing factory for new model
class NewModel < ActiveRecord::Base
  # This model would need a factory when added via migration
end
