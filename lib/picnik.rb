require 'rubygems'
require 'multipart'

class Picnik
  
  PICNIK_API_PARAMETERS = %w(
    apikey import returntype title export export_agent export_field 
    export_method export_title imageid original_thumb redirect replace exclude
    host_name default_in default_out page close_target expand_button
  )
  
  class << self
    
    def url(full_filename, parameters)
      url = ''
      File.open(full_filename) do |file|
        http = Net::HTTP.new('www.picnik.com')
        http.start do |http|
          request = Net::HTTP::Post.new('/service/')
          request.multipart_params = request_parameters(file, parameters)
          response = http.request(request)
          puts response
          url = parse_image_url_from(response)
        end
      end
      url
    end
    
    private
    
    def request_parameters(file, parameters)
      import_parameters = { :import => 'image_data', :image_data => file }
      scrub_parameters(import_parameters.merge(parameters))
    end
    
    def scrub_parameters(parameters)
      scrubbed_parameters = {}
      parameters.each do |key, value| 
        scrubbed_parameters[parameter_key(key)] = value
      end
      scrubbed_parameters
    end
    
    def parameter_key(key)
      key = key.to_s
      PICNIK_API_PARAMETERS.include?(key) ? '_' + key : key
    end
    
    def parse_image_url_from(response)
      body = response.body
      start_index = body.index('>') + 1
      end_index = body.index('<', start_index)
      body.slice((start_index...end_index))
    end
    
  end
  
end