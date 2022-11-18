# frozen_string_literal: true
# encoding: UTF-8

ActiveAdmin.register_page 'BrandPage' do
  menu label: Brand.model_name.human(count: 3)

  action_item :create_brand, only: :index do
    link_to I18n.t('create_brand'), admin_brandpage_new_path
  end

  action_item :add_files, only: :show do
    if http_service.subject!(params.required(:id)).state == 'Draft'
      link_to I18n.t('add_files_to_brand'), admin_brandpage_add_files_to_brand_path(id: params['id'])
    end
  end

  content do
    render partial: 'brands'
  end

  page_action :new, method: :get do
    @brand = Brand.new
    render 'new', layout: 'active_admin'
  end

  page_action :edit, method: :get do
    @brand = http_service.subject!(params.required(:id))
    render 'edit', layout: 'active_admin'
  end

  page_action :update, method: :patch do
    @brand = Brand.new(params.required('brand'))
    unless @brand.valid?
      render 'edit', layout: 'active_admin'
      return
    end

    # TODO: удалить следующий маппинг после того как Матвей исправит функцию update
    new_params = Hash[*brand_params.to_h.map { |key, value| ["New#{key.capitalize}", value] }.flatten]

    http_service.update!(params.required('brand').required('id'), new_params)
    redirect_to admin_brandpage_path
  end

  page_action :delete, method: :delete do
    http_service.delete!(params.required(:id))
    redirect_to admin_brandpage_path
  end


  page_action :show, method: :get do
    @brand = http_service.subject!(params.required(:id))
    render 'show', layout: 'active_admin'
  end

  page_action :create, method: :post do
    @brand = Brand.new(params.required('brand'))
    unless @brand.valid?
      render 'new', layout: 'active_admin'
      return
    end
    http_service.create!(params.required('brand'))
    redirect_to admin_brandpage_path
  end

  page_action :add_files_to_brand, method: :get do
    @brand = http_service.subject!(params.required(:id))
    render 'add_files_to_brand', layout: 'active_admin'
  end

  page_action :save_files_to_brand, method: :post do
    @brand = http_service.subject!(params.required('brand')[:id]) # Только для проверки существования
    params.dig('brand', 'file_name').each do |uploaded_file|
      brand_file = BrandFile::BuildService::Build(uploaded_file)
      content = File.open(uploaded_file.tempfile.path, 'rb', &:read)
      # body = uploaded_file.read.force_encoding("ISO-8859-1").encode("UTF-8")
      # Base64.encode64('12345') 'MTIzNDU='
      http_service.add_file!(params.dig('brand', 'id'), brand_file.full_name, Base64.encode64('12345')[0..-2])
    end
    redirect_to admin_brandpage_show_path(id: params.dig('brand', 'id'))
  end

  controller do
    rescue_from HttpService::HttpServiceError, with: :render_http_error
    def index
      @brand_collection = http_service.index!
    end

    def render_http_error(e)
      @error = e
      render 'shared/error_message', layout: 'active_admin'
    end

    def http_service
      @http_service ||= Brand::HttpService.new
    end

    def brand_params
      params.required('brand').permit('name')
    end
  end
end
