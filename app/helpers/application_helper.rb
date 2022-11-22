module ApplicationHelper
  # Хелпер для отрисовки поля ввода текста,с заголовком и с сообщением об ошибке
  def text_input_field(form, field_name, subject, required = true)
    li_class = required ? 'input required stringish' : 'input stringish'
    label_html = "#{subject.class.human_attribute_name(field_name)}#{input_field_required(required)}"
    content_tag(:li, class: li_class) do
      form.label(field_name, label_html.html_safe, class: 'label') +
        form.text_field(field_name) +
        input_field_error(subject, field_name)
    end
  end

  def text_area_input_field(form, field_name, subject, required = true)
    li_class = required ? 'input required stringish' : 'input stringish'
    label_html = "#{subject.class.human_attribute_name(field_name)}#{input_field_required(required)}"
    content_tag(:li, class: li_class) do
      form.label(field_name, label_html.html_safe, class: 'label') +
        form.text_area(field_name) +
        input_field_error(subject, field_name)
    end
  end

  def input_field_required(required)
    return '' unless required

    content_tag(:abbr, '*', title: 'required')
  end

  def input_field_error(subject, field_name)
    return if subject.errors[field_name].empty?

    content_tag(:p, class: 'inline-errors') do
      subject.errors[field_name].join(', ')
    end
  end

  def delete_brand_file_link(brand, subject)
    link_to I18n.t('delete'), admin_brandpage_delete_file_path(id: brand.id, file_id: subject.id),
            class: 'delete_link member_link c-button c-button--error u-xsmall',
            data: { confirm: I18n.t('delete_file_sure'), method: :delete }
  end
end
