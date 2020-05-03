# frozen_string_literal: true

module Boggle
  module Errors
    MissingToken  = Class.new(StandardError)
    GameNotFound  = Class.new(StandardError)
    GameIsOver    = Class.new(StandardError)
  end
end
