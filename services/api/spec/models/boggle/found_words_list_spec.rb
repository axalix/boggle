# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boggle::FoundWordsList, type: :model do
  let(:id) { 'dCseRLF6kOzNK83OdUzMXw' }
  let(:current_redis_instance) { instance_double(Redis) }

  before do
    allow(Redis).to receive(:current).and_return(current_redis_instance)
    allow(current_redis_instance).to receive(:sismember)
    allow(current_redis_instance).to receive(:smembers)
    allow(current_redis_instance).to receive(:expire)
    allow(current_redis_instance).to receive(:multi)
  end

  subject { described_class.new(id: id) }

  describe '#add_word!' do
    it 'it throws an exception if word has already been added to a list' do
      allow(StringHelper).to receive(:real_word?).and_return(true)
      allow(subject).to receive(:has_word?).and_return(true)
      expect { subject.add_word! '####' }.to raise_error(Boggle::Errors::WordAlreadyExists)
    end
  end

  it 'returns client_data = [] if no words were added' do
    expect(subject.client_data).to eq([])
  end

  it 'returns a list of the added words' do
    words = ['apple', 'pear', 'cherry']
    allow(subject).to receive(:get_all).and_return(words)
    expect(subject.client_data).to eq(words)
  end
end
