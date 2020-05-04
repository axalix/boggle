# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boggle::SearchBoardWord do
  let(:empty_string) { '' }
  let(:board_size) { 4 }
  let(:subject) {
    ->(word) {
      described_class.call(dice_string: dice_string, board_size: board_size, word: word)
    }
  }

  #--------- Empty Board

  describe '#call' do
    context 'empty board' do
      let(:board_size) { 0 }
      let(:dice_string) { empty_string }

      it 'returns false for an empty search' do
        expect(subject[empty_string]).to be false
      end

      it 'returns false for a "regular" search' do
        expect(subject['abc']).to be false
      end
    end

    #--------- Add-"a" board

    context '4x4 board filled with the same symbol' do
      let(:board_size) { 4 }
      let(:dice_string) { 'aaaaaaaaaaaaaaaa' } # 16a

      it 'will detect a 16-a string' do
        expect(subject[dice_string]).to be true
      end

      it 'will not detect a string with all "a" except one "b"' do
        expect(subject['aaaaaaabaaaaaaaa']).to be false # 7a + b + 8a
      end
    end

    #--------- Real board

    context '4 x 4 real-looking board' do
      let(:board_size) { 4 }

      # a b c d
      # e f g h
      # i j k l
      # m n o a
      let(:dice_string) { 'abcdefghijklmnoa' }

      # this is a very edge case, because Boggle doesn't actually allow so short words
      it 'will detect 1-char words' do
        expect(subject['a']).to be true
        expect(subject['d']).to be true
        expect(subject['m']).to be true
        expect(subject['o']).to be true
      end

      it 'will detect horizontal left-to-right words' do
        expect(subject['abcd']).to be true
        expect(subject['efgh']).to be true
        expect(subject['mnoa']).to be true
      end

      it 'will detect horizontal right-to-left words' do
        expect(subject['dcba']).to be true
        expect(subject['hgfe']).to be true
        expect(subject['aonm']).to be true
      end

      it 'will not allow horizontal words with a doubled symbol' do
        expect(subject['abbd']).to be false
      end

      it 'will detect a word with 90 grade degrees' do
        expect(subject['abcdhlaonmie']).to be true
      end

      it 'will not allow words-loops' do
        expect(subject['abcdhlaonmiea']).to be false
      end

      it 'will detect diagonal "/" bottom-to-top words' do
        expect(subject['mjgc']).to be true
        expect(subject['nkl']).to be true
        expect(subject['ifc']).to be true
      end

      it 'will detect diagonal "/" top-to-bottom words' do
        expect(subject['cgjm']).to be true
        expect(subject['lkn']).to be true
        expect(subject['cfi']).to be true
      end


      it 'will detect diagonal "\" bottom-to-top words' do
        expect(subject['akfa']).to be true
        expect(subject['oje']).to be true
        expect(subject['lgb']).to be true
      end

      it 'will detect diagonal "\" top-to-bottom words' do
        expect(subject['afka']).to be true
        expect(subject['ejo']).to be true
        expect(subject['bgl']).to be true
      end

      # a b c d
      # e f g h
      # i j k l
      # m n o a
      it 'will detect multi-directional words' do
        expect(subject['abchknjei']).to be true
        expect(subject['dgjmnoakfabc']).to be true
      end

      it 'will not allow words with intersections' do
        expect(subject['bglhdgj']).to be false
        expect(subject['ijnmj']).to be false
      end

      it 'will not allow to skip symbols' do
        expect(subject['abd']).to be false
        expect(subject['afa']).to be false
        expect(subject['micd']).to be false
      end
    end
  end
end
