# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boggle::GetGameResults do
  let(:subject) { ->(words) { described_class.call(words: words) } }

  describe '#call' do
    it 'returns 0 and empty array for empty array' do
      expect(subject[[]]).to eq({ total_score: 0, words_with_scores: [] })
    end

    it 'makes correct calculations' do
      expect(subject[[
      '',
      'a',
      'bb',
      'ccc',
      'dddd',
      'eeeee',
      'ffffff',
      'ggggggg',
      'hhhhhhhhh',
      'iiiiiiiiii']]).to eq({ total_score: 34, words_with_scores:  [
      'a:0',
      'bb:0',
      'ccc:1',
      'dddd:1',
      'eeeee:2',
      'ffffff:3',
      'ggggggg:5',
      'hhhhhhhhh:11',
      'iiiiiiiiii:11'] })
    end
  end
end
