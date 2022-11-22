# frozen_string_literal: true

# Базовая модель для не ActiveRecord моделей
class BaseModel
  include ActiveModel::Model
  include ActiveModel::Serializers::JSON
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  include Draper::Decoratable

  def initialize(hash_attributes = {})
    self.attributes = hash_attributes
  end

  def attributes=(hash)
    return unless hash

    hash.each do |key, value|
      send("#{translate_field_names_hash[key.to_s]}=", parse_attribute(translate_field_names_hash[key.to_s], value))
    end
  end

  def parse_attribute(attribute_name, value)
    raise NotImplementedError
  end

  def translate_field_names_hash
    raise NotImplementedError
  end

  # Список атрибутов для сериализации
  def attributes
    Hash[*translate_field_names_hash.values.inject([]) do |result, attribute_name|
      result << [attribute_name.to_s, send(attribute_name)]
    end.flatten]
  end

  def to_json(*_args)
    invert_name = translate_field_names_hash.invert
    Hash[*as_json.inject([]) { |result, (key, value)| result << invert_name[key.to_sym] << value }].to_json
  end
end
