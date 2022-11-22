# frozen_string_literal: true

# Команда на релиз
class Command < BaseModel

  attr_accessor :id, :brand_id, :brand_name, :state, :build_url, :postamats, :date_of_create

  validates :brand_id, :postamats, presence: true

  TRANSLATE_FIELD_NAMES = { 'id' => :id,
                            'brandId' => :brand_id,
                            'brandName' => :brand_name,
                            'status' => :state,
                            'build' => :build_url,
                            'dateCreate' => :date_of_create,
                            'postamats' => :postamats }.freeze

  def translate_field_names_hash
    TRANSLATE_FIELD_NAMES
  end

  def parse_attribute(attribute_name, value)
    value
  end

  def self.columns
    %i[id brand_id brand_name state build_url postamats]
  end

  def attributes
    translated_array = translate_field_names_hash.values.inject([]) do |result, attribute_name|
      result << case attribute_name
                when :postamats
                  [attribute_name.to_s, postamats.to_json]
                else
                  [attribute_name.to_s, send(attribute_name)]
                end
    end
    Hash[*translated_array.flatten]
  end

  def to_json(*_args)
    invert_name = { id: 'id',
                    brand_id: 'brandId',
                    brand_name: 'brandName',
                    state: 'status',
                    build_url: 'build',
                    date_of_create: 'dateCreate',
                    postamats: 'postamatIds'}.freeze
    Hash[*as_json.inject([]) { |result, (key, value)| result << invert_name[key.to_sym] << value }].to_json
  end
end
