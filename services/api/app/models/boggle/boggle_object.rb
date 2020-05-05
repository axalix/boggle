# frozen_string_literal: true

module Boggle
  class BoggleObject
    include ActiveModel::Model

    def initialize(attributes = {})
      super
      validate!
    end
  end
end
