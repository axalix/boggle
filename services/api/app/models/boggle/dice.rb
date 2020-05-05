# frozen_string_literal: true

module Boggle
  class Dice
    DICE_EDGES_COUNT = 6
    DEFAULT_TYPE = :classic_16

    # http://www.bananagrammer.com/2013/10/the-boggle-cube-redesign-and-its-effect.html
    TYPES = {
        classic_16: {
            dice_chars: 'AACIOTABILTYABJMOQACDEMPACELRSADENVZAHMORSBIFORXDENOSWDKNOTUEEFHIYEGKLUYEGINTVEHINPSELPSTUGILRUW',
            dice_count: 16
        },

        new_16: {
            dice_chars: 'AAEEGNABBJOOACHOPSAFFKPSAOOTTWCIMOTUDEILRXDELRVYDISTTYEEGHNWEEINSUEHRTVWEIOSSTELRTTYHIMNUQHLNNRZ',
            dice_count:  16
        },

        fancy_25: {
            dice_chars: 'AACIOTABILTYABJMOQACDEMPACELRSADENVZAHMORSBIFORXDENOSWDKNOTUEEFHIYEGKLUYEGINTVEHINPSELPSTUGILRUWAAEEGNABBJOOACHOPSAFFKPSAOOTTWCIMOTUDEILRXDELRVYDISTTY',
            dice_count: 25
        }
    }.freeze

    include ActiveModel::Model

    attr_accessor :type

    def initialize(type = DEFAULT_TYPE)
      raise Boggle::Errors::ImpossibleDice, 'Unknown dice type' unless TYPES.key? type
      @type = type
    end

    # This class method returns a string that represents a full set of dice with fixated, pseudo-random chars
    def self.roll_all_str(type = DEFAULT_TYPE)
      dice = self.new(type)
      result = []
      0.upto(TYPES[type][:dice_count] - 1) { |dice_number| result << dice.roll(dice_number) }
      result.join
    end

    # This method returns a random character for a dice with a particular number, depending on a chars set
    # E.g. dice #1: "C", dice #2: "T", etc.
    def roll(dice_number)
      dt = TYPES[type]

      if !dice_number.is_a?(Numeric) || dice_number < 0 || dice_number > dt[:dice_count] - 1
        raise Boggle::Errors::ImpossibleDice, 'Impossible dice number'
      end

      dt[:dice_chars][dice_number * DICE_EDGES_COUNT + rand(DICE_EDGES_COUNT)]
    end

    def client_data
      TYPES[@type]
    end
  end
end
