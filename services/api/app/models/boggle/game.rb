# frozen_string_literal: true

module Boggle
  class Game < BoggleObject
    include ActiveModel::Model

    attr_accessor :id,
                  :dice_type,
                  :board_size,
                  :game_length_secs

    #----- Data-to-objects mapping

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
      @found_words_list ||= FoundWordsList.new(game: self)
    end

    #----- Persisting logic

    def self.redis_id(id)
      "boggle:game:#{id}"
    end

    def save!
      @id = StringHelper.random_token unless id
      rid = Boggle::Game.redis_id(id)
      Redis.current.mapped_hmset(rid, attributes)
      Redis.current.expire(rid, FORGET_GAME_AFTER_SECONDS)
    end

    def self.exists?(id)
      Redis.current.exists(Boggle::Game.redis_id(id))
    end

    def self.restore(id)
      persisted = Redis.current.hgetall(Boggle::Game.redis_id(id))
      raise Boggle::Errors::GameNotFound if persisted.empty?

      self.new(
        dice_type:        persisted['dice_type'].to_s,
        board_size:       persisted['board_size'].to_i,
        game_length_secs: persisted['game_length_secs'].to_i
      ).tap do |g|
        g.board.dice_string = persisted['dice_string']
        g.timer.started_at  = persisted['started_at'].to_time
        g.timer.stopped_at  = persisted['stopped_at'] == '' ? nil : persisted['stopped_at'].to_time
      end
    end

    #----- Game flow

    def start!
      game_over_check!

      if timer.running?
        raise Boggle::Errors::GameIsRunning, 'Cannot restart a running game'
      end

      self.tap do |g|
        g.id = StringHelper.random_token
        g.board.dice_string = dice.roll_all
        g.found_words_list.create!
        g.timer.start
      end.save!
    end

    def stop!
      game_over_check!
      self.timer.stop
      self.save!
    end

    # game over
    def over?
      timer.over?
    end

    def add_word!(word)
      game_over_check!

      unless timer.running?
        raise Boggle::Errors::GameIsNotRunning, 'Cannot add a word to a not running game'
      end

      found_words_list.add_word! word
    end

    def status
      return :over if over?
      return :running if timer.running?
      nil
    end

    #----- Data

    def attributes
      {
        id:               id,
        dice_type:        dice_type,
        board_size:       board_size,
        game_length_secs: game_length_secs,
        dice_string:      board.dice_string,
        started_at:       timer.started_at,
        stopped_at:       timer.stopped_at
      }
    end

    def client_data
      {
        id:           id,
        board:        board.client_data,
        dice:         dice.client_data,
        seconds_left: timer.seconds_left,
        status:       status
      }
    end

    # def client_data_with_found_words
    #   client_data.merge(found_words: found_words)
    # end

    private def game_over_check!
      if over?
        raise Boggle::Errors::GameIsOver, 'The game is over'
      end
    end
  end
end
