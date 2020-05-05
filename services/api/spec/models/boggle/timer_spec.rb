# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boggle::Timer, type: :model do
  let(:game_length_secs) { 60 }
  let(:current_time) { Time.now }
  subject { described_class.new(game_length_secs) }

  before(:each) do
    allow(Time).to receive(:now).and_return(current_time)
  end

  it 'starts the timer, when #start is called' do
    subject.start
    expect(subject.started_at).to eq current_time
  end

  it 'stops the timer, when #stop is called' do
    subject.stop
    expect(subject.stopped_at).to eq current_time
  end

  it 'is not running if it has never been started' do
    expect(subject.running?).to eq false
  end

  it 'is not running if it was stopped' do
    subject.start
    subject.stop
    expect(subject.running?).to eq false
  end

  it 'is not running if time is up (ended)' do
    subject.start
    allow(Time).to receive(:now).and_return(Time.now + game_length_secs.seconds)
    expect(subject.running?).to eq false
  end

  it 'is running if it was started, not stopped and not yet ended' do
    subject.start
    expect(subject.running?).to eq true
  end

  it 'returns client_data in a correct format' do
    subject.start

    stopped_at = current_time + 1.second
    allow(Time).to receive(:now).and_return(stopped_at)
    subject.stop

    expect(subject.client_data).to eq({
        started_at: current_time,
        stopped_at: stopped_at,
        game_length_secs: game_length_secs
    })
  end
end
