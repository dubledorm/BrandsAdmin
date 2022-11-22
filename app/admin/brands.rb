# frozen_string_literal: true
# encoding: UTF-8

ActiveAdmin.register_page 'BrandPage' do
  menu label: Brand.model_name.human(count: 3)

  action_item :create_brand, only: :index do
    link_to I18n.t('create_brand'), admin_brandpage_new_path
  end

  action_item :add_files, only: :show do
    if http_service.subject!(params.required(:id)).decorate.editable?
      link_to I18n.t('add_files_to_brand'), admin_brandpage_add_files_to_brand_path(id: params['id'])
    end
  end

  action_item :build_brand, only: :show do
    if http_service.subject!(params.required(:id)).decorate.editable?
      link_to I18n.t('build_brand'), admin_brandpage_build_brand_path(id: params['id']),
              data: { confirm: I18n.t('build_brand_sure'), method: :post }
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

    http_service.update!(params.required('brand').required('id'), params.required('brand'))
    redirect_to admin_brandpage_path
  end

  page_action :delete, method: :delete do
    http_service.delete!(params.required(:id))
    redirect_to admin_brandpage_path
  end


  page_action :show, method: :get do
    @brand = http_service.subject!(params.required(:id)).decorate
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
      Brand::AddFileService.add_file(@brand, uploaded_file, http_service)
    end
    redirect_to admin_brandpage_show_path(id: params.dig('brand', 'id'))
  end

  page_action :build_brand, method: :post do
    http_service.build_brand!(params.required('id'))
    redirect_to admin_brandpage_show_path(id: params.dig('id'))
  end

  page_action :delete_file, method: :delete do
    http_service.delete_file!(params.required(:id), params.required(:file_id))
    redirect_to admin_brandpage_show_path(id: params.required(:id))
  end

  controller do
    rescue_from HttpService::HttpServiceError, with: :render_http_error
    def index
      @brand_collection = BrandDecorator.decorate_collection(http_service.index!)
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
