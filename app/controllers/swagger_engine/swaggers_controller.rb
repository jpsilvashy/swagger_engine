require_dependency 'swagger_engine/application_controller'

module SwaggerEngine
  class SwaggersController < ApplicationController
    
    DEFAULT_FILE = "#{Rails.root}/lib/swagger_engine/swagger.json"

    def index
      # redirect_to swagger_path(SwaggerEngine::Swagger.first_key) if SwaggerEngine::Swagger.present?
      @swagger_files = SwaggerEngine::Swagger.swaggers
    end

    def show
      respond_to do |format|
        format.html { @swagger_url = swagger_path(params[:id], format: swagger.extension) }
        format.json { send_file swagger.path, type: swagger.type, disposition: 'inline' }
        format.yaml { send_file swagger.path, type: swagger.type, disposition: 'inline' }
      end
    end

    private
    
    def swagger
      @swagger ||= SwaggerEngine::Swagger.find(params[:id])
    end

  end
end
