# frozen_string_literal: true

module Boggle
  class Board
    DEFAULT_SIZE = 4

    include ActiveModel::Model

    attr_accessor :size,
                  :dice_string # fixated dice representation. Each dice represent 1 character

    def initialize(size = DEFAULT_SIZE)
      @size = size
      @dice_string = ''
    end

    def shuffle(dice)
      # TODO
    end

    def client_data
      {
          size: size,
          chars: chars
      }
    end
  end
end
