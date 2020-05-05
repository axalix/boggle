# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boggle::Timer, type: :model do
  let(:game_length_secs) { 60 }
  let(:started_at) { Time.now }
  let(:stopped_at) { started_at + 1.second }

  subject { described_class.new(game_length_secs) }

  before(:each) do
    allow(Time).to receive(:now).and_return(started_at)
  end

  it 'starts the timer, when #start is called' do
    subject.start
    expect(subject.started_at).to eq started_at
  end

  it 'stops the timer, when #stop is called' do
    allow(Time).to receive(:now).and_return(stopped_at)
    subject.stop

    expect(subject.stopped_at).to eq stopped_at
  end

  describe 'timer has never been started' do
    it 'is up' do
      expect(subject.up?).to eq true
    end

    it 'is not running' do
      expect(subject.running?).to eq false
    end

    it 'is not over' do
      expect(subject.over?).to eq false
    end
  end

  describe 'timer was started' do
    before(:each) { subject.start }

    it 'is up' do
      expect(subject.up?).to eq false
    end

    it 'is running if it was started, not stopped and not yet ended' do
      expect(subject.running?).to eq true
    end

    it 'is not over if timer was started and still ticking' do
      expect(subject.over?).to eq false
    end

    context 'last second is reached' do
      before(:each) { allow(Time).to receive(:now).and_return(Time.now + game_length_secs.seconds) }

      it 'is up' do
        expect(subject.up?).to eq true
      end

      it 'is not running' do
        expect(subject.running?).to eq false
      end

      it 'is over' do
        expect(subject.over?).to eq true
      end
    end

    context 'timer was stopped' do
      before(:each) { subject.stop }

      it 'technically is not yet up based on time and the length of the game' do
        expect(subject.up?).to eq false
      end

      it 'is not running' do
        expect(subject.running?).to eq false
      end

      it 'is over' do
        expect(subject.over?).to eq true
      end
    end
  end

  it 'returns client_data in a correct format' do
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
