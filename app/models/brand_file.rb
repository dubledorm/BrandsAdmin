# frozen_string_literal: true

class BrandFile < BaseModel

  attr_accessor :name, :path, :full_name, :date_of_create, :id

  validates :name, :path, :full_name, :date_of_create, presence: true

  TRANSLATE_FIELD_NAMES = { 'id' => :id,
                            'name' => :name,
                            'path' => :path,
                            'fullName' => :full_name,
                            'dateCreate' => :date_of_create }.freeze

  def translate_field_names_hash
    TRANSLATE_FIELD_NAMES
  end

  def parse_attribute(attribute_name, value)
    value
  end

  def self.columns
    %i[id name path full_name date_of_create]
  end
end
