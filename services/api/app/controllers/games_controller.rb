# frozen_string_literal: true

class GamesController < ApplicationController
  DEFAULT_GAME_LENGTH = 180

  before_action :set_game_token
  before_action :create_game, only: :create
  before_action :set_game, except: :create

  attr_reader :game, :game_token

  def show
    render json: game_attributes
  end

  def create
    game.start!
    render json: game_attributes
  end

  def add_word
    word = StringHelper.sanitize_and_lowercase(params.require(:word))
    game.add_word!(word)
    head :no_content
  end

  def get_results
    game.stop!
    render json: game_attributes(with_results: true)
  end

  #-------------------

  private def game_attributes(with_results: false)
    data = {
      id:           game.id,
      board:        { size: game.board.size, dice_string: game.board.dice_string },
      dice_type:    game.dice_type,
      seconds_left: game.timer.seconds_left,
    }

    data.merge(with_results ? { results: game.results } : { words: game.found_words })
  end

  private def set_game
    raise Boggle::Errors::MissingToken unless game_token
    @game = Boggle::Game.restore(game_token)
  end

  private def create_game
    dice_type = params.require(:dice_type).to_sym
    board_size = dice_type == :fancy_25 ? 5 : 4

    @game = Boggle::Game.new(
      dice_type: Boggle::Dice::TYPES.key?(dice_type) ? dice_type : :classic_16,
      board_size: board_size,
      game_length_secs: DEFAULT_GAME_LENGTH
    )
  end

  private def set_game_token
    @game_token = http_game_token
  end

  private def http_game_token
    request.headers['HTTP_GAME_TOKEN']
  end
end
