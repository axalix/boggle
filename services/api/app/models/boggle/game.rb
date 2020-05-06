# frozen_string_literal: true

module Boggle
  class Game < BoggleObject
    include ActiveModel::Model

    attr_accessor :id,
                  :dice_type,
                  :board_size,
                  :game_length_secs

    def board
      @board ||= Boggle::Board.new(size: board_size)
    end

    def dice
      @dice ||= Dice.new(type: dice_type)
    end

    def timer
      @timer ||= Timer.new(game_length_secs: game_length_secs)
    end

    def found_words_list
      # The list of found words is only available,
      # if game was once started (and "id" was assigned)
      return nil unless id
      @found_words_list ||= FoundWordsList.new(id: id)
    end

    def start!
      return if timer.ticking?
      game_over_check!

      self.tap do |g|
        g.id = StringHelper.random_token
        g.board.dice_string = dice.roll_all
        g.found_words_list.create!
        g.timer.start
      end.save!
     end

    def stop!
      return if timer.stopped?
      timer.stop
      save!
    end

    def add_word!(word)
      game_over_check!

      unless timer.ticking?
        raise Boggle::Errors::GameIsNotRunning, 'Cannot add a word to a not running game'
      end

      # One cube is printed with "Qu".
      # This is because "q" is nearly always followed by "u" in English words.
      word = word.sub('q', 'qu') if word.include?('q') && !word.include?('qu')

      # Boggle allows words of 2 chars, but won't give points for that.
      # One-character words are not allowed
      if word.length < 2
        raise Boggle::Errors::WordIsTooShort, 'This word is too short'
      end

      unless StringHelper.real_word? word
        raise Boggle::Errors::NotAWord, 'This word doesn\'t look like a real word'
      end

      unless board.has_word? word
        raise Boggle::Errors::BoardHasNoWord, 'This word cannot be found on a board'
      end

      found_words_list.add_word! word
    end

    # game over
    def over?
      # game has never been started, so it's not over
      return false unless timer.started?

      !timer.ticking?
    end

    private def game_over_check!
      raise Boggle::Errors::GameIsOver, 'The game is over' if over?
    end

    #----- Persisting logic

    def self.redis_id(id)
      "boggle:game:#{id}"
    end

    def save!
      @id = StringHelper.random_token unless id
      rid = Boggle::Game.redis_id(id)
      Redis.current.mapped_hmset(rid, {
          id:               id,
          dice_type:        dice_type,
          board_size:       board_size,
          game_length_secs: game_length_secs,
          dice_string:      board.dice_string,
          started_at:       timer.started_at,
          stopped_at:       timer.stopped_at
      })
      Redis.current.expire(rid, FORGET_GAME_AFTER_SECONDS)
    end

    def self.exists?(id)
      Redis.current.exists(Boggle::Game.redis_id(id))
    end

    def self.restore(id)
      persisted = Redis.current.hgetall(Boggle::Game.redis_id(id))
      raise Boggle::Errors::GameNotFound if persisted.nil? || persisted.empty?

      self.new(
        dice_type:        persisted['dice_type'].to_sym,
        board_size:       persisted['board_size'].to_i,
        game_length_secs: persisted['game_length_secs'].to_i
      ).tap do |g|
        g.id = persisted['id']
        g.board.dice_string = persisted['dice_string']
        g.timer.started_at  = persisted['started_at'].to_time
        g.timer.stopped_at  = persisted['stopped_at'] == '' ? nil : persisted['stopped_at'].to_time
      end
    end
  end
end
