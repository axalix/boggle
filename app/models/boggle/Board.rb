module Boggle
  class Board
    DEFAULT_SIZE = 4

    include ActiveModel::Model

    attr_accessor :size

    def initialize(size = DEFAULT_SIZE)
      @size = size
    end
  end
end