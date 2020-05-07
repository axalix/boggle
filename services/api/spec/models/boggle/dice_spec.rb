# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boggle::Dice, type: :model do
  let(:alphabet_chars) { 'aaaaaabbbbbbccccccddddddeeeeeeffffffgggggghhhhhhiiiiiijjjjjjkkkkkkllllllmmmmmmnnnnnnoooooopppppp' }

  describe 'classic board with dice of classic_16 is selected' do
    subject { described_class.new(type: :classic_16) }

    it 'throws an exception if the dice number is not a number at all' do
      expect { subject.roll('string') }.to raise_error(Boggle::Errors::ImpossibleDice)
    end

    it 'throws an exception if the dice number is outside of a range' do
      expect { subject.roll(-1) }.to raise_error(Boggle::Errors::ImpossibleDice)
      expect { subject.roll(100) }.to raise_error(Boggle::Errors::ImpossibleDice)
    end

    it 'throws an exception if the dice number is outside of a range' do
      expect { subject.roll(-1) }.to raise_error(Boggle::Errors::ImpossibleDice)
      expect { subject.roll(100) }.to raise_error(Boggle::Errors::ImpossibleDice)
    end

    context 'when we roll a dice' do
      it 'returns a lower latin character' do
        expect(subject.roll(0)).to match(/[aciot]/)
      end

      it 'returns a correct character' do
        with_an_alphabetical_set do
          (0..15).each { |i| expect(subject.roll(i)).to eq (97 + i).chr }
        end
      end
    end

    context 'when we roll all dice' do
      it 'returns a string that represents a result' do
        expect(subject.roll_all).to match(/[a-z]{16}/)
      end

      it 'returns a correct set of characters for each dice' do
        with_an_alphabetical_set do
          expect(subject.roll_all.chars.sort.join).to eq 'abcdefghijklmnop'
        end
      end
    end
  end

  it 'throws an exception if dice of unknown type is selected' do
    expect { described_class.new(type: :unknown_type) }.to raise_error(ActiveModel::ValidationError)
  end

  it 'throws an exception type is not set' do
    expect { described_class.new }.to raise_error(ActiveModel::ValidationError)
  end

  #----------------------

  def with_an_alphabetical_set
    stub_const('Boggle::Dice::TYPES', {
        classic_16: {
            dice_chars: alphabet_chars,
            dice_count: 16
        }
    })

    yield
  end
end
