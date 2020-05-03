# frozen_string_literal: true

module Boggle
  class Board
    DEFAULT_SIZE = 4

    include ActiveModel::Model

    attr_accessor :size

    def initialize(size = DEFAULT_SIZE)
      @size = size
    end

    def client_data
      {
          size: size
      }
    end
  end
end
