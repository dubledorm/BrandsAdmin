# frozen_string_literal: true

# Статус развёртывания брэнда для одного постамата
class PostamatReleaseStatus < BaseModel

  attr_accessor :postamat_number, :state, :errors, :date_of_create, :date_of_update

  validates :postamat_number, :state, presence: true

  TRANSLATE_FIELD_NAMES = { 'number' => :postamat_number,
                            'status' => :state,
                            'dateCreate' => :date_of_create,
                            'dateUpdate' => :date_of_update,
                            'errors' => :errors }.freeze

  def translate_field_names_hash
    TRANSLATE_FIELD_NAMES
  end

  def parse_attribute(attribute_name, value)
    return parse_error_array(value) if attribute_name == :errors
    value
  end

  def self.columns
    %i[postamat_number state errors date_of_create date_of_update]
  end

  def attributes
    translated_array = translate_field_names_hash.values.inject([]) do |result, attribute_name|
      result << case attribute_name
                when :errors
                  [attribute_name.to_s, errors.map(&:attributes).to_json]
                else
                  [attribute_name.to_s, send(attribute_name)]
                end
    end
    Hash[*translated_array.flatten]
  end

  private

  def parse_error_array(array_of_errors)
    array_of_errors.map { |error_hash| ReleaseError.new(error_hash) }
  end
end
