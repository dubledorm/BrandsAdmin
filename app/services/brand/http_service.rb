# frozen_string_literal: true

require 'uri'

class Brand
  class HttpService
    include ActiveModel::Validations

    attr_accessor :brand_service_url

    validates :brand_service_url, presence: true

    ENTRY_POINT = 'brands'
    ADD_FILE_SUFFIX = 'files'

    class HttpServiceNotFoundError < StandardError; end

    class HttpServiceError < StandardError

      def initialize(response_str)
        response_hash = JSON.parse(response_str)
        details_str = response_hash.dig('error', 'details').join(', ')
        message = "#{response_hash.dig('error', 'code')} Details: #{details_str}"
        super(message)
      end
    end

    def initialize
      @brand_service_url = Rails.configuration.x.brand_service_url
      raise ArgumentError, errors.full_messages unless valid?
    end

    def brands!
      target_url = make_url(@brand_service_url, ENTRY_POINT).to_s
      response = Faraday.get(target_url)
      raise HttpServiceError, response.body unless response.status == 200

      JSON.parse(response.body)['data'].map do |brand_hash|
        Brand.new(brand_hash)
      end
    end

    def brand!(id)
      target_url = make_url(@brand_service_url, ENTRY_POINT, id.to_s).to_s
      response = Faraday.get(target_url)
      return Brand.new(JSON.parse(response.body)['data']) if response.status == 200

      raise HttpServiceNotFoundError, "Брэнд с id=#{id} не найден" if response.status == 404

      raise HttpServiceError, response.body
    end

    def create_brand!(brand_name)
      target_url = make_url(@brand_service_url, ENTRY_POINT).to_s
      response = Faraday.post(target_url) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['accept'] = 'text/plain'
        req.body = { name: brand_name }.to_json
      end
      raise HttpServiceError, response.body unless response.status == 200

      Brand.new(JSON.parse(response.body)['data'])
    end

    def update_brand!(id, brand_name)
      target_url = make_url(@brand_service_url, ENTRY_POINT, id.to_s).to_s
      response = Faraday.patch(target_url) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['accept'] = 'text/plain'
        req.body = { newName: brand_name }.to_json
      end

      raise HttpServiceNotFoundError, "Брэнд с id=#{id} не найден" if response.status == 404

      raise HttpServiceError, response.body unless response.status == 200
    end

    def delete_brand!(id)
      target_url = make_url(@brand_service_url, ENTRY_POINT, id.to_s).to_s
      response = Faraday.delete(target_url) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['accept'] = 'text/plain'
      end

      raise HttpServiceNotFoundError, "Брэнд с id=#{id} не найден" if response.status == 404

      raise HttpServiceError, response.body unless response.status == 200
    end


    def add_file!(id, file_full_name, base64_file_body)
      target_url = make_url(@brand_service_url, ENTRY_POINT, id.to_s, ADD_FILE_SUFFIX).to_s
      response = Faraday.put(target_url) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['accept'] = 'text/plain'
        req.body = { fullName: file_full_name, body: base64_file_body }.to_json
      end

      raise HttpServiceNotFoundError, "Брэнд с id=#{id} не найден" if response.status == 404

      raise HttpServiceError, response.body unless response.status == 200
    end

    private

    def make_url(*args)
      parts = args.map { |part| part.end_with?('/') ? part[0..-2] : part }
      parts.join('/')
    end
  end
end
