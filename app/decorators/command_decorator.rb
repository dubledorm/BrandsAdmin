# frozen_string_literal: true

# Декоратор для Command
class CommandDecorator < Draper::Decorator
  delegate_all

  STATE_VALUES = { 'new' => 'Новый', 'processing' => 'В процессе', 'completed' => 'Завершена' }.freeze

  def state
    STATE_VALUES[object.state.downcase] || object.state
  end
end
