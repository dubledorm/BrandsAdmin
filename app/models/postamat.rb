# frozen_string_literal: true

# Постамат
class Postamat < BaseModel

  attr_accessor :id, :number, :url, :brand_id, :description, :date_of_create, :date_of_update

  validates :number, :url, presence: true

  TRANSLATE_FIELD_NAMES = { 'id' => :id,
                            'number' => :number,
                            'url' => :url,
                            'brandId' => :brand_id,
                            'description' => :description,
                            'createDate' => :date_of_create,
                            'updateDate' => :date_of_update }.freeze

  def translate_file_names_hash
    TRANSLATE_FIELD_NAMES
  end

  def parse_attribute(attribute_name, value)
    value
  end

  def self.columns
    %i[id number url description date_of_create date_of_update]
  end
end
