# frozen_string_literal: true

class BrandFile < BaseModel

  attr_accessor :name, :path, :full_name, :date_of_create

  validates :name, :path, :full_name, :date_of_create, presence: true

  TRANSLATE_FIELD_NAMES = { 'name' => :name,
                            'path' => :path,
                            'fullName' => :full_name,
                            'dateCreate' => :date_of_create }.freeze

  def translate_file_names_hash
    TRANSLATE_FIELD_NAMES
  end

  def parse_attribute(attribute_name, value)
    value
  end

  def self.columns
    %i[name path full_name date_of_create]
  end
end
