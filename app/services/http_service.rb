# frozen_string_literal: true

require 'uri'

# Доступ к функция CRUD сервериса брендирования.
# entry_point_str - определяет постфикс к @brand_service_url для обращения к нужному объекту
class HttpService
  include ActiveModel::Validations

  attr_accessor :brand_service_url, :entry_point, :subject_class, :index_data_way

  validates :brand_service_url, :entry_point, :subject_class, :index_data_way, presence: true

  DEFAULT_PAGE_SIZE = 25


  class HttpServiceNotFoundError < StandardError; end

  # Класс ошибки, формируемый на основании отрицательного ответа от функций сервиса брэндирования
  class HttpServiceError < StandardError

    def initialize(response_str)
      response_hash = JSON.parse(response_str)
      details_str = response_hash.dig('error', 'details')&.join(', ')
      message = "#{response_hash.dig('error', 'code')} Details: #{details_str}"
      super(message)
    end
  end

  def initialize(entry_point_str, subject_class)
    @brand_service_url = Rails.configuration.x.brand_service_url
    @entry_point = entry_point_str
    @subject_class = subject_class
    @index_data_way = %w[data collection]
    raise ArgumentError, errors.full_messages unless valid?
  end

  def index!(page_size = DEFAULT_PAGE_SIZE, page_number = 1)
    target_url = make_url(@brand_service_url, entry_point).to_s
    response = Faraday.get(target_url, { 'PageSize' => page_size, 'PageNumber' => page_number })
    raise HttpServiceError, response.body unless response.status == 200

    JSON.parse(response.body).dig(*index_data_way).map do |brand_hash|
      subject_class.new(brand_hash)
    end
  end

  def subject!(id)
    target_url = make_url(@brand_service_url, entry_point, id.to_s).to_s
    response = Faraday.get(target_url)
    return subject_class.new(JSON.parse(response.body)['data']) if response.status == 200

    raise HttpServiceNotFoundError, "Постамат с id=#{id} не найден" if response.status == 404

    raise HttpServiceError, response.body
  end

  def create!(subject_instance)
    target_url = make_url(@brand_service_url, entry_point).to_s
    response = Faraday.post(target_url) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['accept'] = 'text/plain'
      req.body = subject_instance.to_json
    end
    raise HttpServiceError, response.body unless response.status == 200

    subject_class.new(JSON.parse(response.body)['data'])
  end

  def update!(id, subject_attributes)
    target_url = make_url(@brand_service_url, entry_point, id.to_s).to_s
    response = Faraday.patch(target_url) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['accept'] = 'text/plain'
      req.body = subject_attributes.to_json
    end

    raise HttpServiceNotFoundError, "Постамат с id=#{id} не найден" if response.status == 404

    raise HttpServiceError, response.body unless response.status == 200
  end

  def delete!(id)
    target_url = make_url(@brand_service_url, entry_point, id.to_s).to_s
    response = Faraday.delete(target_url) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['accept'] = 'text/plain'
    end

    raise HttpServiceNotFoundError, "Постамат с id=#{id} не найден" if response.status == 404

    raise HttpServiceError, response.body unless response.status == 200
  end

  private

  def make_url(*args)
    parts = args.map { |part| part.end_with?('/') ? part[0..-2] : part }
    parts.join('/')
  end
end

