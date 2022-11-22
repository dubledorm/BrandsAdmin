# frozen_string_literal: true

# Постамат
class ReleaseError < BaseModel

  attr_accessor :message, :detail_message, :date_of_create

  TRANSLATE_FIELD_NAMES = { 'message' => :message,
                            'details' => :detail_message,
                            'dateCreate' => :date_of_create }.freeze

  def translate_field_names_hash
    TRANSLATE_FIELD_NAMES
  end

  def parse_attribute(attribute_name, value)
    value
  end

  def self.columns
    %i[message detail_message date_of_update]
  end
end
