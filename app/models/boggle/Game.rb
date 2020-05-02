module Boggle
  class Game
    include ActiveModel::Model

    attr_accessor :board, :dice, :timer

    def initialize
      # TODO
      @board = Board.new
      @dice = Dice.new(:dice_type)
      @timer = Timer.new
    end
  end
end
