# frozen_string_literal: true
# encoding: UTF-8

ActiveAdmin.register_page 'PostamatPage' do
  menu label: Postamat.model_name.human(count: 3)

  action_item :create_brand, only: :index do
    link_to I18n.t('create_postamat'), admin_postamatpage_new_path
  end

  content do
    render partial: 'postamats'
  end

  page_action :new, method: :get do
    @postamat = Postamat.new
    render 'new', layout: 'active_admin'
  end

  page_action :edit, method: :get do
    @postamat = http_service.subject!(params.required(:id))
    render 'edit', layout: 'active_admin'
  end

  page_action :update, method: :patch do
    @postamat = Postamat.new(params.required('postamat'))
    unless @postamat.valid?
      render 'edit', layout: 'active_admin'
      return
    end
    http_service.update!(params.dig('postamat', 'id'), params.required('postamat'))
    redirect_to admin_postamatpage_path
  end

  page_action :delete, method: :delete do
    http_service.delete!(params[:id])
    redirect_to admin_postamatpage_path
  end


  page_action :show, method: :get do
    @postamat = http_service.subject!(params[:id])
    render 'show', layout: 'active_admin'
  end

  page_action :create, method: :post do
    @postamat = Postamat.new(params.required('postamat'))
    unless @postamat.valid?
      render 'new', layout: 'active_admin'
      return
    end
    http_service.create!(params.required('postamat'))
    redirect_to admin_postamatpage_path
  end

  controller do
    rescue_from HttpService::HttpServiceError, with: :render_http_error
    def index
      @postamat_collection = http_service.index!
    end

    def render_http_error(e)
      @error = e
      render 'shared/error_message', layout: 'active_admin'
    end

    def http_service
      @http_service ||= HttpService.new('postamats', Postamat)
    end
  end
end
