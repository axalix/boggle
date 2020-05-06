# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe '#show' do
    it 'returns ok and status 200' do
      get :show
      expect_good_response response
    end
  end

  describe '#create' do
    it 'returns ok and status 200' do
      post :create
      expect_good_response response
    end
  end

  describe '#add_word' do
    it 'returns ok and status 200' do
      get :add_word
      expect_good_response response
    end
  end

  describe '#get_results' do
  end

  # TODO
  # it 'returns client_data in a correct format' do
  #   subject.id = id
  #
  #   allow(subject.timer).to receive(:seconds_left).and_return seconds_left
  #   allow(subject.board).to receive(:dice_string).and_return dice_string
  #   allow(subject).to receive(:status).and_return status
  #
  #   expect(subject.client_data).to eq({
  #     id:           id,
  #     board:        { dice_string: dice_string, size: board_size },
  #     dice:         { dice_chars: dice_chars, dice_count: dice_count },
  #     seconds_left: seconds_left,
  #     status:       status
  #   })
  # end

  #-------------------------------------------

  private def expect_good_response(response)
    expect(JSON.parse(response.body, symbolize_names: true)).to include({ status: 'ok' })
    expect(response.content_type).to eq 'application/json; charset=utf-8'
  end
end
