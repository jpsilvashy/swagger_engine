require 'minitest/autorun'
require 'minitest/reporters'
require 'ostruct'
MiniTest::Reporters.use!

require_relative '../../lib/swagger_engine/swagger'

module SwaggerEngine
  
  class SwaggerTest < Minitest::Test
    def setup
      SwaggerEngine.configure do |config| 
        config.swaggers = nil 
        config.refs = nil 
      end 
    end
    
    def test_not_present_by_default
      assert_equal false, SwaggerEngine::Swagger.present?
    end
    
    def test_not_present_when_empty
      SwaggerEngine.configure do |config| config.swaggers = {} end
      assert_equal false, SwaggerEngine::Swagger.present?
    end
    
    def test_present_when_set
      configure_one_swagger
      assert_equal true, SwaggerEngine::Swagger.present?
    end
    
    def test_first_is_first_key
      assert_equal('', SwaggerEngine::Swagger.first_key)
      SwaggerEngine.configure do |config|
        config.swaggers = { 
          v1: 'swagger1.yaml',
          v2: 'swagger2.yaml',
        }
      end
      assert_equal :v1, SwaggerEngine::Swagger.first_key
    end

    def test_find
      assert_equal '', SwaggerEngine::Swagger.find(:v1).path
      SwaggerEngine.configure do |config|
        config.swaggers = {
            v1: 'swagger1.yaml',
            v2: 'swagger2.yaml',
        }
      end
      # by symbol
      assert_equal 'swagger1.yaml', SwaggerEngine::Swagger.find(:v1).path
      # or string
      assert_equal 'swagger1.yaml', SwaggerEngine::Swagger.find('v1').path
    end

    def test_extension
      assert_equal '', SwaggerEngine::Swagger.find(:v1).extension

      configure_one_swagger('swagger.yaml')
      assert_equal 'yaml', SwaggerEngine::Swagger.find(:v1).extension

      configure_one_swagger('swagger.json')
      assert_equal 'json', SwaggerEngine::Swagger.find(:v1).extension
    end
    
    def test_type
      assert_equal '', SwaggerEngine::Swagger.find(:v1).type

      configure_one_swagger('swagger.yaml')
      assert_equal 'application/x-yaml', SwaggerEngine::Swagger.find(:v1).type

      configure_one_swagger('swagger.json')
      assert_equal 'application/json', SwaggerEngine::Swagger.find(:v1).type
    end

    def test_refs
      SwaggerEngine.configure do |config|
        config.references = { ref1: 'reference.yaml'}
      end
      assert_equal 'reference.yaml', SwaggerEngine::Swagger.find(:ref1).path
    end
    
    private
    
    def configure_one_swagger(path = 'swagger.yaml')
      SwaggerEngine.configure do |config| 
        config.swaggers = { v1: path} 
      end
    end

    def configure_two_swagger
      SwaggerEngine.configure do |config|
        config.swaggers = {
            v1: 'swagger1.yaml',
            v2: 'swagger2.yaml',
        }
      end
    end
    
    
  end

  module_function
  
  def configuration
    @configuration ||= OpenStruct.new
  end

  def configure
    yield(configuration)
  end
  
end
