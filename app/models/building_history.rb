# frozen_string_literal: true

class BuildingHistory < BaseModel

  attr_accessor :success, :error_message, :date_of_create

  validates :date_of_create, presence: true

  TRANSLATE_FIELD_NAMES = { 'isSuccess' => :success,
                            'errorMessage' => :error_message,
                            'dateCreate' => :date_of_create }.freeze

  def translate_file_names_hash
    TRANSLATE_FIELD_NAMES
  end

  def parse_attribute(attribute_name, value)
    value
  end
end
