# frozen_string_literal: true

class Brand < BaseModel

  attr_accessor :id, :name, :state, :files, :building_history, :date_of_create, :date_of_update

  validates :name, presence: true

  TRANSLATE_FIELD_NAMES = { 'id' => :id,
                            'name' => :name,
                            'state' => :state,
                            'files' => :files,
                            'buildingHistory' => :building_history,
                            'dateCreate' => :date_of_create,
                            'dateUpdate' => :date_of_update }.freeze

  def initialize_dup(other)
    @files = []
    @building_history = []
    super
  end
  def translate_file_names_hash
    TRANSLATE_FIELD_NAMES
  end

  def parse_attribute(attribute_name, value)
    return parse_file_array(value) if attribute_name == :files
    return parse_building_history_array(value) if attribute_name == :building_history

    value
  end

  def self.columns
    %i[id name state date_of_create date_of_update]
  end

  def self.primary_key
    'id'
  end

  def self.inheritance_column
    'id'
  end

  # def self.ransack(params = {}, options = {})
  #   byebug
  #   Ransack::Search.new(self, params, options)
  # end

  # def ransack(hash_attributes = {})
  #   ActiveRecord.new.ransack()
  # end

  # Список атрибутов для сериализации
  def attributes
    translated_array = translate_file_names_hash.values.inject([]) do |result, attribute_name|
      result << case attribute_name
                when :building_history
                  [attribute_name.to_s, building_history.map(&:attributes).to_json]
                when :files
                  [attribute_name.to_s, files.map(&:attributes).to_json]
                else
                  [attribute_name.to_s, send(attribute_name)]
                end
    end
    Hash[*translated_array.flatten]
  end

  private

  def parse_file_array(array_of_files)
    array_of_files.map { |file_hash| BrandFile.new(file_hash) }
  end

  def parse_building_history_array(array_of_history)
    array_of_history.map { |file_hash| BuildingHistory.new(file_hash) }
  end
end
