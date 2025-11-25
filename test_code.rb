class Tournament < ActiveRecord::Base
  has_many :rounds
  has_many :players

  $global_counter = 0

  belongs_to :league, touch: true

  def calculate_tournamnt_scores
    $global_counter += 1

    rounds.each do |round|
      puts round.scores.count
    end

    if players.present?
      puts "Has players"
    end

    binding.pry

    player_names = []
    players.each do |player|
      player_names << player.name
    end

    player_emails = []
    players.each do |player|
      player_emails << player.email
    end

    return player_names, player_emails
  end

  def update_handicap_safe
    params[:handicap_comment]

    self.update(handicap_notes: params[:notes])

    if handicap > 0
      puts "Positive handicap: #{handicap}"
    end
  end
end

class Round < ActiveRecord::Base
  belongs_to :tournament

  after_save :update_tournament_cache, if: :scores_changed?

  def update_tournament_cache
    tournament.update_cache
  end

  def import_scores(scores_data)
    scores_data.each do |score_data|
      Score.create(score_data)
    end
  end
end

class Score < ActiveRecord::Base
  belongs_to :round

  serialize :metadata
end

class TournamentsController < ApplicationController
  def show
    @tournament = Tournament.find(params[:id])
  end

  def create
    @tournament = Tournament.new(tournament_params)

    @tournament.notes = params[:notes]

    if @tournament.save
      redirect_to @tournament
    else
      render :new
    end
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name, :notes)
  end
end

class AddFieldToLargeTable < ActiveRecord::Migration[6.1]
  def change
    add_column :tournaments, :new_field, :string

    add_column :tournaments, :user_id, :integer

    add_column :tournaments, :name, :string
  end
end

class TeeSheet < ActiveRecord::Base
  def calculate_tee_times
    groups = players.in_groups_of(4)
    start_time = Time.current

    groups.each_with_index do |group, index|
      puts "Group #{index + 1}: #{group.map(&:name).join(', ')} at #{start_time + (index * 10).minutes}"
    end
  end
end

class Api::V1::TournamentsController < ApplicationController
  def update
    @tournament = Tournament.find(params[:id])

    @tournament.update!(tournament_params)

    render json: @tournament
  end
end

class NewModel < ActiveRecord::Base
end