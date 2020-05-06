# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boggle::GetGameResults do
  let(:subject) { ->(words_with_scores) { described_class.call(words_with_scores: words_with_scores) } }

  describe '#call' do
    it 'returns 0 and empty array for empty array' do
      expect(subject[[]]).to eq({ total_score: 0, words_with_scores: [] })
    end

    it 'makes correct calculations' do
      expect(subject[[['sentence', 11.0], ['point', 2.0], ['dot', 1.0]]]).to eq(
        { total_score: 14,
          words_with_scores: [['sentence', 11], ['point', 2], ['dot', 1]] })
    end
  end
end
