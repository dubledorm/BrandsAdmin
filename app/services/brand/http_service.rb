# frozen_string_literal: true

require 'uri'

class Brand
  # Расширение общего HttpService для работы с коллекцией брэндов
  class HttpService < HttpService
    ENTRY_POINT = 'brands'
    ADD_FILE_SUFFIX = 'files'
    DELETE_FILE_SUFFIX = 'files'

    def initialize
      super(ENTRY_POINT, Brand)
      @index_data_way = %w[data collection]
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

    def delete_file!(id, file_id)
      target_url = make_url(@brand_service_url, ENTRY_POINT, id.to_s, DELETE_FILE_SUFFIX, file_id).to_s
      response = Faraday.delete(target_url) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['accept'] = 'text/plain'
      end

      raise HttpServiceNotFoundError, "Не найден брэнд с Id=#{id}" if response.status == 404

      raise HttpServiceError, response.body unless response.status == 200
    end
  end
end
