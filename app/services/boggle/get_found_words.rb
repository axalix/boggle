# frozen_string_literal: true

module Boggle
  class GetFoundWords
    include Callable

    def initialize(game:)
      # TODO
      @game = game
    end

    def call
      # TODO
      Boggle::Game.new

      # raise Boggle::Errors::GameNotFound, 'Cannot find a game for a token'
    end
  end
end
