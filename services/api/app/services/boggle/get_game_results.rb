# frozen_string_literal: true

module Boggle
  class GetGameResults
    include Callable

    attr_reader :words

    def initialize(words:)
      @words = words
    end

    def call
      total_score = 0
      words_with_scores = words.each_with_object([]) do |word, new_list|
        ws = word_score(word)
        total_score += ws
        new_list << "#{word}:#{ws}" unless word.empty?
      end

      {
          total_score:        total_score,
          words_with_scores:  words_with_scores
      }
    end

    # https://en.wikipedia.org/wiki/Boggle
    private def word_score(word)
      l = word.length
      return 0 if l < 3
      return 1 if (l == 3) || (l == 4)
      return 2 if l == 5
      return 3 if l == 6
      return 5 if l == 7
      11
    end
  end
end
