# frozen_string_literal: true

module Boggle
  module Errors
    MissingToken  = Class.new(StandardError)

    # Game
    GameNotFound      = Class.new(StandardError)
    GameNotStarted    = Class.new(StandardError)
    GameIsRunning     = Class.new(StandardError)
    GameIsNotRunning  = Class.new(StandardError) # e.g. has never been started
    GameIsOver        = Class.new(StandardError) # was running before, but not anymore

    # Board
    BoardHasNoWord = Class.new(StandardError)

    # Dice
    ImpossibleDice = Class.new(StandardError)

    # Word
    WordAlreadyExists = Class.new(StandardError)
    NotAWord = Class.new(StandardError)
  end
end
