# frozen_string_literal: true

require 'set'

module Boggle
  class SearchBoardWord
    include Callable

    # Cartesian product for all possible directions
    ORTS = [-1, 0, 1].product([-1, 0, 1]) - [[0, 0]]

    attr_reader :chars, :board_last_idx, :word

    def initialize(dice_string:, board_size:, word:)
      @chars = self.class.string_to_chars(dice_string: dice_string, board_size: board_size)
      @board_last_idx = board_size - 1
      @word = word
    end

    def call
      0.upto board_last_idx do |i|
        0.upto board_last_idx do |j|
          return true if iterated?(i, j)
        end
      end

      false
    end

    private def iterated?(i, j, word_idx = 0, visited = Set.new)
      return false if lame_coordinate?(i, j, word_idx, visited)

      # successfully reached the end of the word => the entire word is detected on a board
      return true if word_idx == word.size - 1

      visited.add [i, j]

      ORTS.any? { |ort| iterated?(ort[0] + i, ort[1] + j, word_idx + 1, visited) } || false
    end

    #--------------------

    private def lame_coordinate?(i, j, word_idx, visited)
      outside_boundaries?(i, j)     ||    # current cell is outside of the board boundaries
          visited.include?([i, j])  ||    # current cell has already been checked
          chars[i][j] != word[word_idx]   # current cell doesn't contain a char we are looking
    end

    private def outside_boundaries?(i, j)
      i < 0 || j < 0 || i > board_last_idx || j > board_last_idx
    end

    def self.string_to_chars(dice_string:, board_size:)
      return [] if board_size.zero?
      dice_string.chars.each_slice(board_size).to_a
    end
  end
end
