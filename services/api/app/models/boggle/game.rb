# frozen_string_literal: true

module Boggle
  class Game
    FORGET_GAME_AFTER_SECONDS = 1.hour.seconds

    include ActiveModel::Model

    attr_accessor :id,
                  :dice_type,
                  :board_size,
                  :game_length_secs,
                  :dice_string

    def initialize(dice_type, board_size, game_length_secs)
      @id               = nil
      @dice_type        = dice_type
      @board_size       = board_size
      @game_length_secs = game_length_secs
      @dice_string      = ''
    end

    #----- Data-to-objects mapping

    def board
      @board ||= Boggle::Board.new(board_size)
    end

    def dice
      @dice ||= Dice.new(dice_type)
    end

    def timer
      @timer ||= Timer.new(game_length_secs)
    end

    def found_words
      @found_words ||= Boggle::GetFoundWords.call(game: self)
    end

    #----- Persisting logic

    def self.redis_id(id)
      "boggle:game:#{id}"
    end

    def save!
      unless id
        raise Boggle::Errors::GameNotStarted, 'Cannot save a game if it has never been started'
      end

      rid = Boggle::Game.redis_id(id)
      Redis.current.mapped_hmset(rid, attributes)
      Redis.current.expire(rid, FORGET_GAME_AFTER_SECONDS)
    end

    def self.restore(id)
      persisted = Redis.current.hgetall(Boggle::Game.redis_id(id))
      self.new(persisted['dice_type'].to_s, persisted['board_size'].to_i, persisted['game_length_secs'].to_i).tap do |g|
        g.dice_string = persisted['dice_string']
        g.timer.started_at = persisted['started_at'].to_time
        g.timer.stopped_at = persisted['stopped_at'] == '' ? nil : persisted['stopped_at'].to_time
      end
    end

    #----- Game flow

    def start!
      if over?
        raise Boggle::Errors::GameIsOver, 'Cannot restart a stopped game'
      end

      self.tap do |g|
        g.id = StringHelper.random_token
        g.dice_string = dice.roll_all
        g.timer.start
      end.save!
    end

    def stop!
      if over?
        raise Boggle::Errors::GameIsOver, 'Cannot stop a stopped game'
      end

      self.timer.stop
      self.save!
    end

    # game over
    def over?
      timer.over?
    end

    def add_word!(word)
      if timer.over?
        raise Boggle::Errors::GameIsOver, 'Cannot add a word for a stopped game'
      end

      Boggle::AddWord.call(game: self, word: word)

      # TODO: track scores
      self.save!
    end

    #----- Data

    def status
      return 'over' if over?
      return 'running' if timer.running?
      nil
    end

    def attributes
      {
        id:               id,
        dice_type:        dice_type,
        board_size:       board_size,
        game_length_secs: game_length_secs,
        dice_string:      dice_string,
        started_at:       timer.started_at,
        stopped_at:       timer.stopped_at
      }
    end

    def client_data
      {
          id:           id,
          board:        board.client_data,
          dice:         dice.client_data,
          timer:        timer.client_data,
          dice_string:  dice_string,
          status:       status
      }
    end

    def client_data_with_found_words
      client_data.merge(found_words: found_words)
    end
  end
end
