# frozen_string_literal: true

module Boggle
  class Game
    include ActiveModel::Model

    attr_accessor :id,
                  :dice_type,
                  :board_size,
                  :game_length_secs,
                  :dice_string

    def initialize(dice_type, board_size, game_length_secs)
      @id               = nil
      @dice_type        = dice_type
      @boards_size      = board_size
      @game_length_secs = game_length_secs
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

    def save!
      Boggle::Save.call(game: self)
    end

    def self.restore(id)
      Boggle::Restore.call(id: id)
    end

    def self.delete!(id)
      Boggle::Delete.call(id: id)
    end

    #----- Game flow

    def start!
      if timer.over?
        raise Boggle::Errors::GameIsOver, 'Cannot restart a stopped game'
      end

      self.tap do |g|
        g.id = StringHelper.random_token
        g.dice_string = dice.roll_all
        g.timer.start
      end.save!
    end

    def stop!
      if timer.over?
        raise Boggle::Errors::GameIsOver, 'Cannot stop a stopped game'
      end

      self.timer.stop
      self.save!
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
      return 'over' if timer.over?
      return 'running' if timer.running?
      nil
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
