# frozen_string_literal: true

# Декоратор для Брэндов
class BrandDecorator < Draper::Decorator
  delegate_all

  STATE_VALUES = {  'draft' => 'Черновик',
                    'build' => 'Собирается',
                    'successfullybuilt' => 'Собран',
                    'builderror' => 'Ошибка сборки' }.freeze

  def editable?
    object.state == 'Draft'
  end

  def state
    STATE_VALUES[object.state.downcase] || object.state
  end
end
