# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StringHelper do
  it 'sanitizes and lowercases' do
    expect(StringHelper.sanitize_and_lowercase('   Wo Rd     ')).to eq 'word'
  end

  it 'calculates boggle_score right' do
    expect(StringHelper.word_boggle_score('')).to eq 0
    expect(StringHelper.word_boggle_score('a')).to eq 0
    expect(StringHelper.word_boggle_score('bb')).to eq 0
    expect(StringHelper.word_boggle_score('ccc')).to eq 1
    expect(StringHelper.word_boggle_score('eeeee')).to eq 2
    expect(StringHelper.word_boggle_score('ffffff')).to eq 3
    expect(StringHelper.word_boggle_score('ggggggg')).to eq 5
    expect(StringHelper.word_boggle_score('hhhhhhhh')).to eq 11
    expect(StringHelper.word_boggle_score('iiiiiiiii')).to eq 11
  end
end
