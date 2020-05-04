# frozen_string_literal: true

module Boggle
  class Game
    include ActiveModel::Model

    attr_accessor :id,
                  :board,
                  :dice,
                  :timer,
                  :score,
                  :found_words

    def initialize
      # TODO
      @id = nil
      @board  = Board.new
      @dice   = Dice.new(:dice_type)
      @timer  = Timer.new
      @score  = 0
      @found_words = []
    end

    def save!
      Boggle::Save.call(game: self)
    end

    def self.restore(id)
      Boggle::Restore.call(id: id)
    end

    def self.delete!(id)
      Boggle::Delete.call(id: id)
    end

    def start!
      if over?
        raise Boggle::Errors::GameIsOver, 'Cannot restart a stopped game'
      end

      self.tap do |g|
        g.id = StringHelper.random_token
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

    def add_word!(word)
      if over?
        raise Boggle::Errors::GameIsOver, 'Cannot add a word for a stopped game'
      end

      Boggle::AddWord.call(game: self, word: word)

      # TODO: track scores
      self.save!
    end

    def running?
      timer.running?
    end

    def over?
      !running?
    end

    def status
      over? ? 'over' : 'running'
    end

    def found_words
      @found_words ||= Boggle::GetFoundWords.call(game: self)
    end

    def client_data
      {
          id:     id,
          board:  board.client_data,
          dice:   dice.client_data,
          timer:  timer.client_data,
          score:  score,
          status: status
      }
    end

    def client_data_with_found_words
      client_data.merge(found_words: found_words)
    end
  end
end
