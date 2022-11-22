# frozen_string_literal: true
# encoding: UTF-8

ActiveAdmin.register_page 'CommandStatusPage' do
  menu false

  page_action :show, method: :get do
    @command_status = http_service.subject!(params[:id])
    render 'show', layout: 'active_admin'
  end


  controller do

    rescue_from HttpService::HttpServiceError, with: :render_http_error
    def render_http_error(e)
      @error = e
      render 'shared/error_message', layout: 'active_admin'
    end

    def http_service
      @http_service ||= CommandStatus::HttpService.new
    end
  end
end
