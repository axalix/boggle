# frozen_string_literal: true

module Boggle
  class FoundWordsList < BoggleObject
    attr_accessor :game

    validates :game, presence: true

    def redis_id
      "boggle:words:#{game.id}"
    end

    def create!
      rid = redis_id
      Redis.current.multi do |r|
        r.sadd(rid, '')
        r.expire(rid, FORGET_GAME_AFTER_SECONDS)
      end
    end

    def save!(word)
      r.sadd(redis_id, word)
    end

    def has_word?(word)
      Redis.current.sismember(redis_id, word)
    end

    def get_all
      Redis.current.smembers(redis_id)
    end

    def add_word!(word)
      unless StringHelper.real_word? word
        raise Boggle::Errors::NotAWord, 'This word doesn\'t look like a real word'
      end

      unless game.board.has_word? word
        raise Boggle::Errors::BoardHasNoWord, 'This word cannot be found on a board'
      end

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
