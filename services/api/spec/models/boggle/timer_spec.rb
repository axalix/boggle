# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boggle::Timer, type: :model do
  let(:game_length_secs) { 60 }
  let(:started_at) { Time.now }
  let(:stopped_at) { started_at + 1.second }

  subject { described_class.new(game_length_secs: game_length_secs) }

  describe 'timer has never been started' do
    it 'is not running' do
      expect(subject.ticking?).to eq false
    end

    it 'started? is false' do
      expect(subject.started?).to eq false
    end

    it 'stopped? is false' do
      expect(subject.stopped?).to eq false
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

    it 'is running' do
      expect(subject.ticking?).to eq true
    end

    it 'started? is true' do
      expect(subject.started?).to eq true
    end

    it 'shows seconds left' do
      allow(Time).to receive(:now).and_return(subject.started_at + game_length_secs - 1.second)
      expect(subject.seconds_left).to eq 1
    end

    context 'last second is reached' do
      before { allow(Time).to receive(:now).and_return(Time.now + game_length_secs.seconds) }

      it 'is not running' do
        expect(subject.ticking?).to eq false
      end

      it 'shows 0 seconds left' do
        expect(subject.seconds_left).to eq 0
      end
    end

    context 'timer was stopped' do
      before {
        subject.started_at = started_at
        allow(Time).to receive(:now).and_return(stopped_at)
        subject.stop
      }

      it 'has a correct "stopped_at"' do
        expect(subject.stopped_at).to eq stopped_at
      end

      it 'stopped? is true' do
        expect(subject.stopped?).to eq true
      end

      it 'is not running' do
        expect(subject.ticking?).to eq false
      end

      it 'shows 0 seconds left' do
        expect(subject.seconds_left).to eq 0
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
