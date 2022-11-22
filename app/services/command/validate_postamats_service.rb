# frozen_string_literal: true

class Command
  # Проверить правильность ввода списка постаматов для релиза брэнда
  class ValidatePostamatsService
    VALIDATE_REGEXP = /^\s*([\dabcdef]+\s*,\s*)*([\dabcdef]+\s*)$/.freeze

    def self.valid?(command)
      unless command.postamats =~ VALIDATE_REGEXP
        command.errors[:postamats] << I18n.t('bad_postamats_input')
        return false
      end

      true
    end
  end
end
