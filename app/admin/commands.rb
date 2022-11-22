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
