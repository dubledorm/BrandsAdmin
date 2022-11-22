# frozen_string_literal: true

# Декоратор для BuildingHistory
class BuildingHistoryDecorator < Draper::Decorator
  delegate_all

  SUCCESS_VALUES = { 'true' => 'Успешно', 'false' => 'Плачевный' }.freeze

  def success
    SUCCESS_VALUES[object.success.to_s] || object.success.to_s
  end
end
