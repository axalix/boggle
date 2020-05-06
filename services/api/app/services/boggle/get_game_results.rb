# frozen_string_literal: true

module Boggle
  class GetGameResults
    include Callable

    attr_reader :words_with_scores

    def initialize(words_with_scores:)
      @words_with_scores = words_with_scores
    end

    def call
      total_score = 0
      words_with_scores.map do |w|
        w[1] = w[1].to_i
        total_score += w.second
        w
      end

      {
          total_score:        total_score,
          words_with_scores:  words_with_scores
      }
    end
  end
end
