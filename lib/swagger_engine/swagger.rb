module SwaggerEngine
  class Swagger
    attr_reader :key, :path
    def initialize(id, path)
       @id = id || ''
       @path = path || '' 
    end
    
    def extension
      File.extname(@path).delete('.')
    end

    def type
      case extension
        when 'yaml', 'yml'
          'application/x-yaml'
        when 'json'
          'application/json'
        else
          ''
      end
    end
    
    def title
      data['info']['title']
    end

    def description
      data['info']['description']
    end
    
    def version
      data['info']['version']
    end
    
    def data
      @data ||= case extension
        when 'yaml', 'yml'
          YAML.load_file(@path)
        when 'json'
          file = File.read('file-name-to-be-read.json')
          JSON.parse(file)
        else
          {}
      end
    end
    
    def self.present?
      self.swaggers.size > 0
    end
    
    def self.first_key
      self.swaggers.keys.first || ''
    end
    
    def self.find(id)
      self.new(id.to_sym, all[id] || all[id.to_sym])
    end
    
    def self.swaggers
      SwaggerEngine.configuration.swaggers || {}
    end

    def self.references
      SwaggerEngine.configuration.references || {}
    end
    
    def self.all
      swaggers.merge(references)
    end
  end
end
