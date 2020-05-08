# frozen_string_literal: true

module Boggle
  class Dice < BoggleObject
    DICE_EDGES_COUNT = 6

    # http://www.bananagrammer.com/2013/10/the-boggle-cube-redesign-and-its-effect.html
    TYPES = {
        classic_16: {
            dice_chars: 'aaciotabiltyabjmoqacdempacelrsadenvzahmorsbiforxdenoswdknotueefhiyegkluyegintvehinpselpstugilruw',
            dice_count: 16
        },

        new_16: {
            dice_chars: 'aaeegnabbjooachopsaffkpsaoottwcimotudeilrxdelrvydisttyeeghnweeinsuehrtvweiosstelrttyhimnuqhlnnrz',
            dice_count:  16
        },

        fancy_25: {
            dice_chars: 'aaciotabiltyabjmoqacdempacelrsadenvzahmorsbiforxdenoswdknotueefhiyegkluyegintvehinpselpstugilruwaaeegnabbjooachopsaffkpsaoottwcimotudeilrxdelrvydistty',
            dice_count: 25
        }
    }.freeze

    attr_accessor :type

    validates :type, inclusion: { in: TYPES.keys }, presence: true

    # This method returns a "dice_string": selected (shuffled) chars on all the dice + shuffle the dice as well
    def roll_all
      result = []
      0.upto(TYPES[type][:dice_count] - 1) { |dice_number| result << self.roll(dice_number) }
      result.shuffle.join
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
  end
end
