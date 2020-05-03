# frozen_string_literal: true

module Boggle
  class Restore
    include Callable

    def initialize(id:)
      # TODO
      @id = id
    end

    def call
      # TODO
      Boggle::Game.new

      # raise Boggle::Errors::GameNotFound, 'Cannot find a game for a token'
    end
  end
end
