# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :set_game_token
  before_action :set_game, except: :create

  attr_reader :game, :game_token

  def show
    render json: game_data
  end

  def create
    # TODO: parameters shouldn't be "magic numbers". Builders or factory calls are welcome here.
    # I left it "as is" to save some time for frontend
    @game = Boggle::Game.new(dice_type: :classic_16, board_size: 4, game_length_secs: 180)
    game.start!
    render json: game_data
  end

  def add_word
    # TODO: word - "empty string" validation
    word = StringHelper.sanitize_and_lowercase(params.require(:word))
    game.add_word!(word)
    render :nothing
  end

  def get_results
    game.stop!
    render json: game_results_data
  end

  #-------------------

  private def game_data
    {
      id:           game.id,
      board:        { size: game.board.size, dice_string: game.board.dice_string },
      dice:         Boggle::Dice::TYPES[game.dice_type],
      seconds_left: game.timer.seconds_left,
      words:        game.found_words_list.get_all
    }
  end

  private def game_results_data
    # results could be cached / persisted too, so we won't recalculate them every time,
    # but I didn't do to save some time for the frontend part
    game_data
      .without(:words)
      .merge(results: Boggle::GetGameResults.call(words_with_scores: game.found_words_list.get_all(with_scores: true)))
  end

  private def set_game
    raise Boggle::Errors::MissingToken unless game_token
    @game = Boggle::Game.restore(game_token)
  end

  private def set_game_token
    @game_token = http_game_token
  end

  private def http_game_token
    request.headers['HTTP_GAME_TOKEN']
  end
end
