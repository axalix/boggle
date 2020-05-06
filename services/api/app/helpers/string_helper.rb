# frozen_string_literal: true

module StringHelper
  def self.random_token
    SecureRandom.urlsafe_base64
  end

  def self.sanitize_and_lowercase(word)
    word.downcase.gsub(/[^a-z]/, '')
  end

  def self.real_word?(word)
    DICTIONARY_REDIS.sismember('dict', word)
  end
end
