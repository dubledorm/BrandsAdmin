# frozen_string_literal: true

# Декоратор для CommandStatus
class CommandStatusDecorator < Draper::Decorator
  delegate_all

  SUCCESS_VALUES = { 'true' => 'Успешно', 'false' => 'Ошибка' }.freeze

  def success
    SUCCESS_VALUES[object.success.to_s] || object.success.to_s
  end
end
