# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boggle::Game, type: :model do
  let(:current_redis_instance) { instance_double(Redis) }

  let(:board_size) { 4 }
  let(:dice_type) { :classic_16 }
  let(:game_length_secs) { 180 }
  let(:random_token) { 'dCseRLF6kOzNK83OdUzMXw' }
  let(:redis_id) { "boggle:game:#{random_token}" }

  let(:id) { random_token }
  let(:seconds_left) { 7 }
  let(:dice_string) { 'abcdefghiklmnop' }
  let(:dice_chars) { 'aaciotabiltyabjmoqacdempacelrsadenvzahmorsbiforxdenoswdknotueefhiyegkluyegintvehinpselpstugilruw' }
  let(:dice_count) { 16 }
  let(:status) { 'running' }
  let(:word) { 'apple' }

  before do
    allow(Redis).to receive(:current).and_return(current_redis_instance)
    allow(current_redis_instance).to receive(:mapped_hmset)
    allow(current_redis_instance).to receive(:expire)
    allow(current_redis_instance).to receive(:exists)
    allow(current_redis_instance).to receive(:hgetall)
    allow(current_redis_instance).to receive(:multi)
  end

  subject { described_class.new(
    dice_type: dice_type,
    board_size: board_size,
    game_length_secs: game_length_secs
  ) }

  describe 'instantiation' do
    it 'returns a board of a correct size' do
      expect(subject.board.size).to eq board_size
    end

    it 'returns a dice of a correct type' do
      expect(subject.dice.type).to eq dice_type
    end

    it 'returns a timer with a correct game length' do
      expect(subject.timer.game_length_secs).to eq game_length_secs
    end

    it 'returns a list of found words, linked to a game' do
      expect(subject.found_words_list.game).to eq subject
    end

    it 'returns status = nil' do
      expect(subject.status).to eq nil
    end
  end

  describe '#save!' do
    it 'should assign new id, when "id" is nil' do
      new_id = 'QRy4RoN7YE9Tp0nkttDznw"'
      allow(StringHelper).to receive(:random_token).and_return new_id
      subject.id = nil
      subject.save!
      expect(subject.id).to eq new_id
    end

    it 'should use current "id" if it is not nil' do
      subject.id = id
      subject.save!
      expect(subject.id).to eq id
    end
  end

  describe '#restore' do
    let(:serialized_content) { {
        'id'                => 'Lob4mASJLvsbBK7gDCHP1w',
        'dice_type'         => 'classic_16',
        'board_size'        => '4',
        'game_length_secs'  => '100',
        'dice_string'       => 'iaaaeerxetektiuw',
        'started_at'        => '2020-05-05 16:28:25 +0000',
        'stopped_at'        => '2020-05-05 16:28:30 +0000'
    } }

    it 'returns a game model with correct attributes' do
      allow(current_redis_instance).to receive(:hgetall).and_return serialized_content
      game = described_class.restore(id)

      expect(game.dice_type).to eq 'classic_16'
      expect(game.board_size).to eq 4
      expect(game.game_length_secs).to eq 100
      expect(game.board.dice_string).to eq 'iaaaeerxetektiuw'
      expect(game.timer.started_at).to eq '2020-05-05 16:28:25 +0000'.to_time
      expect(game.timer.stopped_at).to eq '2020-05-05 16:28:30 +0000'.to_time
    end

    it 'it throws an exception if a game cannot be found in Redis' do
      allow(current_redis_instance).to receive(:hgetall).and_return nil
      expect { described_class.restore(id) }.to raise_error(Boggle::Errors::GameNotFound)
    end
  end

  describe 'add_word!' do
    it 'it throws an exception if a game is not running' do
      allow(subject).to receive(:over?).and_return false
      expect { subject.add_word!(word) }.to raise_error(Boggle::Errors::GameIsNotRunning)
    end

    it 'calls "found_words_list" model to add a word' do
      allow(subject).to receive(:over?).and_return false
      allow(subject.timer).to receive(:running?).and_return true
      expect(subject.found_words_list).to receive(:add_word!).with(word)
      subject.add_word! word
    end
  end

  describe 'game is not over' do
    before { allow(subject).to receive(:over?).and_return false }

    context 'starting a game' do
      before {
        allow(StringHelper).to receive(:random_token).and_return random_token
      }

      it 'it throws an exception if a game is already running' do
        allow(subject.timer).to receive(:running?).and_return true
        expect { subject.start! }.to raise_error(Boggle::Errors::GameIsRunning)
      end

      it 'assigns an "id"' do
        subject.start!
        expect(subject.id).to eq random_token
      end

      it 'rolls the dice' do
        subject.start!
        expect(subject.board.dice_string).to match(/[a-z]{#{dice_count}}/)
      end

      it 'initializes a list of found words' do
        expect(subject.found_words_list).to receive(:create!)
        subject.start!
      end

      it 'starts the timer' do
        expect(subject.timer).to receive(:start)
        subject.start!
      end

      it 'persists a game' do
        expect(subject).to receive(:save!)
        subject.start!
      end

      context 'stopping a game' do
        it 'stops the timer' do
          expect(subject.timer).to receive(:stop)
          subject.stop!
        end

        it 'persists a game' do
          expect(subject).to receive(:save!)
          subject.stop!
        end
      end
    end

    it 'returns a "running" status if timer is still running' do
      allow(subject.timer).to receive(:running?).and_return true
      expect(subject.status).to eq :running
    end
  end

  describe 'game is over' do
    before { allow(subject).to receive(:over?).and_return true }

    it 'throws an exception, when starting a game' do
      expect { subject.start! }.to raise_error(Boggle::Errors::GameIsOver)
    end

    it 'it throws an exception, when stopping a game' do
      expect { subject.stop! }.to raise_error(Boggle::Errors::GameIsOver)
    end

    it 'it throws an exception, when trying to add a game' do
      expect { subject.add_word!(word) }.to raise_error(Boggle::Errors::GameIsOver)
    end

    it 'returns status "over"' do
      expect(subject.status).to eq :over
    end
  end

  it 'detects the game is over, when timer is over' do
    allow(subject.timer).to receive(:over?).and_return true
    expect(subject.over?).to eq true
  end

  it 'returns client_data in a correct format' do
    subject.id = id

    allow(subject.timer).to receive(:seconds_left).and_return seconds_left
    allow(subject.board).to receive(:dice_string).and_return dice_string
    allow(subject).to receive(:status).and_return status

    expect(subject.client_data).to eq({
      id:           id,
      board:        { dice_string: dice_string, size: board_size },
      dice:         { dice_chars: dice_chars, dice_count: dice_count },
      seconds_left: seconds_left,
      status:       status
    })
  end
end
