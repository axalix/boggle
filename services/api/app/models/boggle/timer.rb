# frozen_string_literal: true

module Boggle
  class Timer
    DEFAULT_MAX_GAME_LENGTH_SECS = 180

    include ActiveModel::Model

    attr_reader :started_at, :stopped_at, :game_length_secs

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

    def running?
      !@started_at.nil? && # never started
      @stopped_at.nil?  && # started, but manually stopped
      (Time.now - started_at).seconds < game_length_secs # just ended / expired
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
