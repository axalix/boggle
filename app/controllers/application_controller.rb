# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from StandardError, with: :standard_error_response

  def standard_error_response(exception)
    render json: { message: exception }, status: :unprocessable_entity
  end
end
