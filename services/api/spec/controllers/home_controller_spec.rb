# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe '#index' do
    it 'returns ok and status 200' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end
end
