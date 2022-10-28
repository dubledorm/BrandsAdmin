# frozen_string_literal: true

class Column
  include ActiveModel::Model

  attr_accessor :name

  def initialize(hash_attributes = {})
    super(hash_attributes)
    self.attributes = hash_attributes
  end

  def attributes=(hash)
    return unless hash

    hash.each do |key, value|
      send("#{key}=", value.to_s)
    end
  end
end
