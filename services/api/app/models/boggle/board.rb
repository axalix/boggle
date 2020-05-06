# frozen_string_literal: true

module Boggle
  class Board < BoggleObject
    # "size" is a board dimension. For example for a board 4x4, "size" is 4
    # "dice_string": selected (shuffled) chars on all the dice
    attr_accessor :size, :dice_string

    validates :size, presence: true, numericality: { only_integer: true }

    def has_word?(word)
      # One cube is printed with "Qu".
      # This is because "q" is nearly always followed by "u" in English words.
      Boggle::SearchBoardWord.call(
        dice_string:  dice_string,
        board_size:   size,
        word:         word.sub('qu', 'q') # the board sees "qu" as "q"
      )
    end

    def client_data
      {
          size: size,
          dice_string: dice_string
      }
    end
  end
end
