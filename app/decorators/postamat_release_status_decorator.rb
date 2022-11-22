# frozen_string_literal: true

# Декоратор для PostamatReleaseStatus
class PostamatReleaseStatusDecorator < Draper::Decorator
  delegate_all

  STATE_VALUES = { 'new' => 'Новый', 'processing' => 'В процессе',
                   'completed' => 'Завершён', 'failed' => 'Завершён с ошибкой' }.freeze

  def errors
    h.content_tag(:div) do
      object.errors.each do |release_error|
        release_error.decorate.to_html
      end
    end
  end

  def state
    STATE_VALUES[object.state.downcase] || object.state
  end
end
