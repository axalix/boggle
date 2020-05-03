# frozen_string_literal: true

module StringHelper
  def self.random_token
    SecureRandom.urlsafe_base64
  end
end
