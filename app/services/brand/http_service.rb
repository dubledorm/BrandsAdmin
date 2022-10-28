# frozen_string_literal: true

require 'uri'

class Brand
  class HttpService
    include ActiveModel::Validations

    attr_accessor :brand_service_url

    validates :brand_service_url, presence: true

    ENTRY_POINT = 'brands'

    def initialize
      @brand_service_url = Rails.configuration.x.brand_service_url
      raise ArgumentError, errors.full_messages unless valid?
    end

    def brands
      target_url = make_url(@brand_service_url, ENTRY_POINT).to_s
      response = Faraday.get(target_url)
      JSON.parse(response.body)['data']
    end

    def brand(id)
      target_url = make_url(@brand_service_url, ENTRY_POINT, id.to_s).to_s
      response = Faraday.get(target_url)
      byebug
      Brand.new(JSON.parse(response.body)['data'])
    end

    private

    def make_url(*args)
      parts = args.map { |part| part.end_with?('/') ? part[0..-2] : part }
      parts.join('/')
    end
  end
end
