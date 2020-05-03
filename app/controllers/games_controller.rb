# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :set_game_token
  before_action :set_game, except: :create

  attr_reader :game, :game_token

  def show
    render json: @game.client_data_with_found_words
  end

  def destroy
    Boggle::Game.delete!(game_token)
    render :nothing
  end

  def create
    # Player can only play one game at a time with the same token
    # In case previous game exists, it should be deleted
    Boggle::Game.delete!(game_token) if game_token
    @game = Boggle::Game.new
    @game.start!
    render json: @game.client_data
  end

  def add_word
    word = params.require(:word)
    @game.add_word!(word)
    render :nothing
  end

  def stop
    @game.stop!
    render json: @game
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
