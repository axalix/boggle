# frozen_string_literal: true

module Boggle
  class FoundWordsList < BoggleObject
    attr_accessor :id

    validates :id, presence: true

    def redis_id
      "boggle:words:#{id}"
    end

    def create!
      # First value is '*' is added to hold a key.
      # This allows to set "r.expire" only once for a Redis key,
      # instead of each time, when the word is added
      rid = redis_id
      Redis.current.multi do |r|
        r.zadd(rid, -1, '*')
        r.expire(rid, FORGET_GAME_AFTER_SECONDS)
      end
    end

    def save!(word)
      Redis.current.zadd(redis_id, StringHelper.word_boggle_score(word), word)
    end

    def has_word?(word)
      !Redis.current.zrank(redis_id, word).nil?
    end

    def get_all(with_scores: false)
      # first value is '*', so it should be excluded.
      # See comments for "#create!"
      Redis.current.zrevrange(redis_id, 0, -2, with_scores: with_scores)
    end

    def add_word!(word)
      if has_word? word
        raise Boggle::Errors::WordAlreadyExists, 'This word already exists in a list'
      end

      save! word
    end
  end
end
