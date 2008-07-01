require 'rubygems'
require 'multipart'

class Picnik
  
  PICNIK_API_PARAMETERS = %w(
    apikey sig expires locale import returntype title export export_agent 
    export_field export_method export_title redirect imageid original_thumb 
    replace thumbs out_format out_quality out_maxsize out_maxwidth out_maxheight
    exclude host_name default_in default_out page close_target expand_button
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
          url = parse_image_url_from(response)
        end
      end
      url
    end
    
    private
    
    def request_parameters(file, parameters)
      required_parameters = { :import => 'image_data', :image_data => file, :returntype => 'text' }
      scrub_parameters(required_parameters.merge(parameters))
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
      response.body
    end
    
  end
  
end