# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boggle::FoundWordsList, type: :model do
  let(:redis) { Redis.current }
  let(:id) { 'dCseRLF6kOzNK83OdUzMXw' }
  let(:word) { 'sentence' }
  let(:word2) { 'point' }
  let(:word3) { 'dot' }
  let(:rid) { subject.redis_id }
  let(:test_has_word) { -> (word_par) { !redis.zrank(rid, word_par).nil? } }

  subject { described_class.new(id: id) }

  describe '#add_word!' do
    it 'it throws an exception if word has already been added to a list' do
      subject.add_word! word
      expect { subject.add_word! word }.to raise_error(Boggle::Errors::WordAlreadyExists)
    end

    it 'saves the words' do
      expect(test_has_word[word]).to eq false
      subject.add_word! word
      expect(test_has_word[word]).to eq true
    end
  end

  it 'creates a list with an empty string as a first value' do
    subject.create!
    expect(test_has_word['*']).to eq true
  end

  it 'saves the words' do
    expect(test_has_word[word]).to eq false
    subject.save! word
    expect(test_has_word[word]).to eq true
  end

  it 'returns false for #has_word? if word is not saved' do
    expect(subject.has_word?(word)).to eq false
  end

  it 'return true for #has_word? if word is saved' do
    redis.zadd(rid, 1, word)
    expect(subject.has_word?(word)).to eq true
  end

  it 'returns a unique list of saved words for #get_all' do
    # First value is '*' is added to hold a key.
    # This allows to set "r.expire" only once for a Redis key,
    # instead of each time, when the word is added
    ['*', word, word2, word3, word, word2].map { |w| redis.zadd(rid, StringHelper.word_boggle_score(w), w) }
    expect(subject.get_all).to eq [word, word2, word3]
  end

  it 'returns a unique list of saved words with scores for each words for #get_all' do
    ['*', word, word2, word3, word, word2].map { |w| redis.zadd(rid, StringHelper.word_boggle_score(w), w) }
    expect(subject.get_all(with_scores: true)).to eq [['sentence', 11.0], ['point', 2.0], ['dot', 1.0]]
  end
end
