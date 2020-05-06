# frozen_string_literal: true

module Boggle
  class FoundWordsList < BoggleObject
    attr_accessor :id

    validates :id, presence: true

    def redis_id
      "boggle:words:#{id}"
    end

    def create!
      rid = redis_id
      Redis.current.multi do |r|
        r.sadd(rid, '')
        r.expire(rid, FORGET_GAME_AFTER_SECONDS)
      end
    end

    def save!(word)
      Redis.current.sadd(redis_id, word)
    end

    def has_word?(word)
      Redis.current.sismember(redis_id, word)
    end

    def get_all
      Redis.current.smembers(redis_id)
    end

    def add_word!(word)
      if has_word? word
        raise Boggle::Errors::WordAlreadyExists, 'This word already exists in a list'
      end

      save! word
    end

    def client_data
      get_all || []
    end
  end
end
