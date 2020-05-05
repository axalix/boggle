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
      # There are some exceptional rare words without "u" after "q",
      # but we will ignore them for the sake of simplicity.
      # This is a list of such words:
      # https://en.wiktionary.org/wiki/Appendix:English_words_containing_Q_not_followed_by_U
      Boggle::SearchBoardWord.call(
        dice_string:  dice_string,
        board_size:   size,
        word:         word.sub('qu', 'q')
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
