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

  def self.word_boggle_score(word)
    l = word.length
    return 0 if l < 3
    return 1 if (l == 3) || (l == 4)
    return 2 if l == 5
    return 3 if l == 6
    return 5 if l == 7
    11
  end
end
