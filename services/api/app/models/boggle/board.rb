# frozen_string_literal: true

module Boggle
  class Board < BoggleObject
    # "size" is a board dimension. For example for a board 4x4, "size" is 4
    # "dice_string": selected (shuffled) chars on all the dice
    attr_accessor :size, :dice_string

    validates :size, presence: true, numericality: { only_integer: true }

    def client_data
      {
          size: size,
          dice_string: dice_string
      }
    end
  end
end
