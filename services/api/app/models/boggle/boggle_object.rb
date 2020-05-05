# frozen_string_literal: true

module Boggle
  class BoggleObject
    include ActiveModel::Model

    FORGET_GAME_AFTER_SECONDS = 1.hour.seconds

    def initialize(attributes = {})
      super
      validate!
    end
  end
end
