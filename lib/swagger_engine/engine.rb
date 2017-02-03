module SwaggerEngine
  class Engine < ::Rails::Engine
    isolate_namespace SwaggerEngine
    config.assets.paths << config.root.join('app/assets')
    config.assets.paths << config.root.join('vendor/assets')
    
    config.assets.precompile << %r{swagger_engine/.*\.(?:js|js.map|css)\z}
    config.assets.precompile += Dir.glob(config.root.join('vendor/assets/swagger_engine/swagger_ui/images/*'))
    config.assets.precompile << %r{\.(?:svg|eot|woff|woff2|ttf|otf)\z} # fonts
  end

  class Configuration
    attr_accessor :swaggers
    attr_accessor :references
    attr_accessor :admin_username
    attr_accessor :admin_password
  end
  
  class << self
    attr_writer :configuration
  end

  module_function
  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    yield(configuration)
  end
end
