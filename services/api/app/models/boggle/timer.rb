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

    # time is up
    def up?
      return true if started_at.nil? || game_length_secs.nil?

      (Time.now - started_at).seconds >= game_length_secs
    end

    # timer is started, not manually stopped and not yet up
    def running?
      !started_at.nil? && stopped_at.nil? && !up?
    end

    # timer was running before, but not anymore
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
