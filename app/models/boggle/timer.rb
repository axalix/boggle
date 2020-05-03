# frozen_string_literal: true

module Boggle
  class Timer
    include ActiveModel::Model

    attr_accessor :started_at
  end
end
