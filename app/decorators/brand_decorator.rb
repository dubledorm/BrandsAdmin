# frozen_string_literal: true

# Декоратор для Брэндов
class BrandDecorator < Draper::Decorator
  delegate_all

  STATE_VALUES = {  'draft' => 'Черновик',
                    'build' => 'Собирается',
                    'successfullybuilt' => 'Собран',
                    'builderror' => 'Ошибка сборки' }.freeze

  def editable?
    %w[draft builderror].include?(object.state.downcase)
  end

  def relisable?
    %w[successfullybuilt].include?(object.state.downcase)
  end

  def building_history
    object.building_history.map(&:decorate)
  end

  def state
    STATE_VALUES[object.state.downcase] || object.state
  end
end
