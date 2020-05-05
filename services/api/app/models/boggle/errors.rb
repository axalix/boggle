# frozen_string_literal: true

module Boggle
  module Errors
    MissingToken  = Class.new(StandardError)

    # Game
    GameNotFound    = Class.new(StandardError)
    GameNotStarted  = Class.new(StandardError)
    GameIsRunning   = Class.new(StandardError)
    GameIsOver      = Class.new(StandardError)

    # Dice
    ImpossibleDice = Class.new(StandardError)
  end
end
