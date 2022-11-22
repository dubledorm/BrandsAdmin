# frozen_string_literal: true

# Статус команды на релиз
class CommandStatus < BaseModel

  attr_accessor :postamat_release_statuses, :success, :error

  TRANSLATE_FIELD_NAMES = { 'data' => :postamat_release_statuses,
                            'isSuccess' => :success,
                            'error' => :error }.freeze

  def translate_field_names_hash
    TRANSLATE_FIELD_NAMES
  end

  def parse_attribute(attribute_name, value)
    return parse_postamat_release_statuses_array(value) if attribute_name == :postamat_release_statuses
    value
  end

  def self.columns
    %i[success error]
  end

  def attributes
    translated_array = translate_field_names_hash.values.inject([]) do |result, attribute_name|
      result << case attribute_name
                when :postamat_release_statuses
                  [attribute_name.to_s, postamat_release_statuses.map(&:to_json)]
                else
                  [attribute_name.to_s, send(attribute_name)]
                end
    end
    Hash[*translated_array.flatten]
  end

  private

  def parse_postamat_release_statuses_array(array_of_postamat_release_statuses)
    array_of_postamat_release_statuses.map { |postamat_release_status_hash| PostamatReleaseStatus.new(postamat_release_status_hash) }
  end
end
