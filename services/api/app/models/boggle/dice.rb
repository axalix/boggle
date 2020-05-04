# frozen_string_literal: true

module Boggle
  class Dice
    DEFAULT_EDGES_COUNT = 6

    include ActiveModel::Model

    attr_accessor :type

    def initialize(type)
      # TODO
      @type = type
    end

    def client_data
      {
          type: type
      }
    end
  end
end
