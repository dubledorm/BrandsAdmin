# frozen_string_literal: true

# Декоратор для Ошибок релиза
class ReleaseErrorDecorator < Draper::Decorator
  delegate_all

  def to_html
    h.concat(h.content_tag(:div) do
      h.content_tag(:div, h.content_tag(:strong, object.date_of_create)) +
        h.content_tag(:div, h.content_tag(:strong, object.message)) +
        h.content_tag(:div, object.detail_message)
    end)
  end
end
