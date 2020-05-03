# frozen_string_literal: true

module Boggle
  class Timer
    MAX_GAME_LENGTH_SECONDS = 180

    include ActiveModel::Model

    attr_accessor :started_at, :stopped_at

    def initialize
      @started_at = nil
      @stopped_at = nil
    end

    def start
      @started_at = Time.now
    end

    def stop
      @stopped = Time.now
    end

    def running?
      return true unless @stopped_at.nil?
      return false if @started_at.nil?

      (Time.now - started_at).seconds < MAX_GAME_LENGTH_SECONDS
    end

    def client_data
      {
          started_at: started_at
      }
    end
  end
end
