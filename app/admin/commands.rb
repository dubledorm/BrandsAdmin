# frozen_string_literal: true
# encoding: UTF-8

ActiveAdmin.register_page 'CommandPage' do
  menu label: Command.model_name.human(count: 3)

  content do
    render partial: 'commands'
  end

  page_action :show, method: :get do
    @command = http_service.subject!(params[:id])
    render 'show', layout: 'active_admin'
  end

  page_action :new, method: :get do
    @brand = Brand::HttpService.new.subject!(params.required('brand_id'))
    @command = Command.new
    @command.brand_id = @brand.id
    @command.brand_name = @brand.name
    render 'new', layout: 'active_admin'
  end

  page_action :create, method: :post do
    @command = Command.new
    @command.brand_id = (params.required('command').dig('brand_id'))
    @command.brand_name = (params.required('command').dig('brand_name'))
    @command.postamats = (params.required('command').dig('postamats'))
    unless @command.valid? && Command::ValidatePostamatsService.valid?(@command)
      render 'new', layout: 'active_admin'
      return
    end

    @command.postamats = @command.postamats.split(',').map { |item| item.gsub(' ', '') }
    http_service.create!(@command)
    redirect_to admin_commandpage_path
  end

  controller do

    rescue_from HttpService::HttpServiceError, with: :render_http_error
    def index
      @command_collection = CommandDecorator.decorate_collection(http_service.index!)
    end

    def render_http_error(e)
      @error = e
      render 'shared/error_message', layout: 'active_admin'
    end

    def http_service
      @http_service ||= HttpService.new('Commands', Command)
    end
  end
end
