# frozen_string_literal: true

class GamesController < ApplicationController
  def show
    render json: { status: 'ok' }
  end

  def destroy
    render json: { status: 'ok' }
  end

  def create
    render json: {
        status: 'ok',
        token: self.class.generate_token
    }
  end

  def add_word
    render json: { status: 'ok' }
  end

  def self.generate_token
    SecureRandom.urlsafe_base64
  end
end
