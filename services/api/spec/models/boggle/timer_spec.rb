# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boggle::Timer, type: :model do
  let(:game_length_secs) { 60 }
  let(:started_at) { Time.now }
  let(:stopped_at) { started_at + 1.second }

  subject { described_class.new(game_length_secs: game_length_secs) }

  describe 'timer has never been started' do
    # time is up - no time left
    it 'is up' do
      expect(subject.up?).to eq true
    end

    it 'is not running' do
      expect(subject.running?).to eq false
    end

    it 'is not over' do
      expect(subject.over?).to eq false
    end

    it 'shows 0 seconds_left left' do
      expect(subject.seconds_left).to eq 0
    end

    it 'is impossible to stop it' do
      expect(subject.stop).to eq false
      expect(subject.stopped_at).to eq nil
    end
  end

  describe 'timer was started' do
    before {
      allow(Time).to receive(:now).and_return(started_at)
      subject.start
    }

    it 'has a correct "started_at"' do
      expect(subject.started_at).to eq started_at
    end

    it 'is up' do
      expect(subject.up?).to eq false
    end

    it 'is running if it was started, not stopped and is ticking (not expired)' do
      expect(subject.running?).to eq true
    end

    it 'is not over if timer was started and still ticking' do
      expect(subject.over?).to eq false
    end

    it 'shows seconds left if it is less than the length of the game' do
      allow(Time).to receive(:now).and_return(subject.started_at + game_length_secs - 1.second)
      expect(subject.seconds_left).to eq 1
    end

    context 'last second is reached' do
      before { allow(Time).to receive(:now).and_return(Time.now + game_length_secs.seconds) }

      it 'is up' do
        expect(subject.up?).to eq true
      end

      it 'is not running' do
        expect(subject.running?).to eq false
      end

      it 'is over' do
        expect(subject.over?).to eq true
      end

      it 'shows 0 seconds left' do
        expect(subject.seconds_left).to eq 0
      end
    end

    context 'timer was started and then stopped' do
      before {
        subject.started_at = started_at
        allow(Time).to receive(:now).and_return(stopped_at)
        subject.stop
      }

      it 'has a correct "stopped_at"' do
        expect(subject.stopped_at).to eq stopped_at
      end

      it 'is up' do
        expect(subject.up?).to eq true
      end

      it 'is not running' do
        expect(subject.running?).to eq false
      end

      it 'is over' do
        expect(subject.over?).to eq true
      end

      it 'shows 0 seconds left' do
        expect(subject.seconds_left).to eq 0
      end

      it 'is impossible to stop it again' do
        subject.stopped_at = stopped_at
        allow(Time).to receive(:now).and_return(Time.now + 10.seconds)
        expect(subject.stop).to eq false
        expect(subject.stopped_at).to eq stopped_at
      end
    end
  end

  it 'returns client_data in a correct format' do
    allow(Time).to receive(:now).and_return(started_at)
    subject.start

    allow(Time).to receive(:now).and_return(stopped_at)
    subject.stop

    expect(subject.client_data).to eq({
        started_at: started_at,
        stopped_at: stopped_at,
        game_length_secs: game_length_secs
    })
  end
end
