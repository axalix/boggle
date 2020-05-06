# frozen_string_literal: true

module Boggle
  class Timer < BoggleObject
    attr_accessor :started_at, :stopped_at, :game_length_secs

    validates :game_length_secs, presence: true, numericality: { only_integer: true }

    def start
      @started_at = Time.now
    end

    def stop
      # can't stop a timer if it has never been started
      return nil unless started?

      # can't stop a timer if it is already stopped
      return @stopped_at if stopped?

      # it is naturally stopped
      return nil unless ticking?

      @stopped_at = Time.now
    end

    # a diff between the length of the game and what is passed. Zero if negative
    def seconds_left
      # never started or stopped => no time left
      return 0 if !started? || stopped?

      s = (Time.now - started_at).seconds
      s >= game_length_secs ? 0 : (game_length_secs - s).to_i
    end

    def ticking?
      seconds_left > 0
    end

    def started?
      !!@started_at
    end

    def stopped?
      !!@stopped_at
    end
  end
end
