# frozen_string_literal: true

module Boggle
  class Timer
    DEFAULT_MAX_GAME_LENGTH_SECS = 180

    include ActiveModel::Model

    attr_accessor :started_at, :stopped_at, :game_length_secs

    def initialize(game_length_secs = DEFAULT_MAX_GAME_LENGTH_SECS)
      @started_at = nil
      @stopped_at = nil
      @game_length_secs = game_length_secs
    end

    def start
      @started_at = Time.now
    end

    def stop
      @stopped_at = Time.now
    end

    # a diff between the length of the game and seconds pass. Zero if negative
    def seconds_left
      return 0 if started_at.nil? || !stopped_at.nil?
      s = (Time.now - started_at).seconds
      s >= game_length_secs ? 0 : (game_length_secs - s).to_i
    end

    # time is up if timer has never been started or 0 seconds left
    def up?
      return true if started_at.nil? || game_length_secs.nil?
      seconds_left.zero?
    end

    # not manually stopped and not yet up
    def running?
      stopped_at.nil? && !up?
    end

    # Timer was running before, but not anymore
    # This usually means the game is over.
    # On case timer has never been started "over?" returns false
    def over?
      !started_at.nil? && !running?
    end

    def client_data
      {
          started_at: started_at,
          stopped_at: stopped_at,
          game_length_secs: game_length_secs
      }
    end
  end
end
