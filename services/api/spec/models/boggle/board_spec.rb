# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boggle::Board, type: :model do
  let(:dice_string) { 'ABCDEFGHIJKLMNOPQRSTUVWXY' }
  let(:size) { 5 }

  subject { described_class.new(size: size) }

  it 'throws an exception if size is not set' do
    expect { described_class.new }.to raise_error(ActiveModel::ValidationError)
  end

  it 'returns client_data in a correct format' do
    subject.dice_string = dice_string

    expect(subject.client_data).to eq({
      size: size,
      dice_string: dice_string
    })
  end
end
