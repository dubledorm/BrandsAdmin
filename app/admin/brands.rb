# frozen_string_literal: true

ActiveAdmin.register_page 'BrandPage' do
  menu label: Brand.model_name.human(count: 3)

  action_item :create_brand, only: :index do
    link_to I18n.t('create_brand'), admin_brandpage_new_path
  end

  action_item :add_files, only: :show do
    link_to I18n.t('add_files_to_brand'), admin_brandpage_add_files_to_brand_path(id: params['id'])
  end

  content do
    render partial: 'brands'
  end

  page_action :new, method: :get do
    @brand = Brand.new
    render 'new', layout: 'active_admin'
  end

  page_action :edit, method: :get do
    @brand = Brand::HttpService.new.brand!(params[:id])
    render 'edit', layout: 'active_admin'
  end

  page_action :update, method: :patch do
    @brand = Brand.new(params['brand'])
    unless @brand.valid?
      render 'edit', layout: 'active_admin'
      return
    end
    Brand::HttpService.new.update_brand!(params.dig('brand', 'id'), params.dig('brand', 'name'))
    redirect_to admin_brandpage_path
  end

  page_action :delete, method: :delete do
    @brand = Brand::HttpService.new.brand!(params[:id])
    Brand::HttpService.new.delete_brand!(params[:id])
    redirect_to admin_brandpage_path
  end


  page_action :show, method: :get do
    @brand = Brand::HttpService.new.brand!(params[:id])
    render 'show', layout: 'active_admin'
  end

  page_action :create, method: :post do
    @brand = Brand.new(params['brand'])
    unless @brand.valid?
      render 'new', layout: 'active_admin'
      return
    end
    Brand::HttpService.new.create_brand!(params.dig('brand', 'name'))
    redirect_to admin_brandpage_path
  end

  page_action :add_files_to_brand, method: :get do
    @brand = Brand::HttpService.new.brand!(params[:id])
    render 'add_files_to_brand', layout: 'active_admin'
  end

  page_action :save_files_to_brand, method: :post do
    @brand = Brand::HttpService.new.brand!(params.dig('brand', 'id'))
    redirect_to admin_brandpage_show_path(id: params.dig('brand', 'id'))
  end

  controller do
    #    rescue_from Brand::HttpService, with: :render_http_error
    def index
      @brand_collection = Brand::HttpService.new.brands!
    end

    # def render_http_error(e)
    #
    # end
  end
end
