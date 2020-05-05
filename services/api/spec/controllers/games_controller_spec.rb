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

  #-------------------------------------------

  private def expect_good_response(response)
    expect(JSON.parse(response.body, symbolize_names: true)).to include({ status: 'ok' })
    expect(response.content_type).to eq 'application/json; charset=utf-8'
  end
end
