# frozen_string_literal: true

require 'uri'

class CommandStatus
  # Расширение общего HttpService для работы с коллекцией брэндов
  class HttpService < HttpService
    ENTRY_POINT = 'Commands'

    def initialize
      super(ENTRY_POINT, CommandStatus)
      @index_data_way = %w[]
    end

    def subject!(id)
      target_url = make_url(@brand_service_url, entry_point, id.to_s).to_s
      response = Faraday.get(target_url)
      return subject_class.new(JSON.parse(response.body)) if response.status == 200

      raise HttpServiceNotFoundError, "Объект с id=#{id} не найден" if response.status == 404

      raise HttpServiceError, response.body
    end
  end
end
