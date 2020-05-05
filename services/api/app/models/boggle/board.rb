# frozen_string_literal: true

module Boggle
  class Board
    DEFAULT_SIZE = 4

    include ActiveModel::Model

    # "size" is a board dimension. For example for a board 4x4, "size" is 4
    # "dice_string": selected (shuffled) chars on all the dice
    attr_reader :size, :dice_string

    def initialize(dice_string, size = DEFAULT_SIZE)
      @size = size
      @dice_string = dice_string
    end

    def client_data
      {
          size: size,
          dice_string: dice_string
      }
    end
  end
end
