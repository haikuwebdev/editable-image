module EditableImage
  class Picnik
  
    PICNIK_API_PARAMETERS = %w(
      apikey sig expires locale import returntype title export export_agent 
      export_field export_method export_title redirect imageid original_thumb 
      replace thumbs out_format out_quality out_maxsize out_maxwidth out_maxheight
      exclude host_name default_in default_out page close_target expand_button
    )
  
    def self.url(full_filename, parameters)
      raise EditableImage::InvalidParametersError unless api_key_in?(parameters)
      url = ''
      File.open(full_filename) do |file|
        raise EditableImage::InvalidFileTypeError unless image?(full_filename)
        http = Net::HTTP.new('www.picnik.com')
        http.start do |http|
          request = Net::HTTP::Post.new('/service/')
          request.multipart_params = request_parameters(file, parameters)
          response = http.request(request)
          url = response.body
        end
      end
      url
    rescue EditableImage::InvalidFileTypeError => e
      raise e, "File must be an image."
    rescue EditableImage::InvalidParametersError => e
      raise e, "Parameters must include the apikey."
    rescue Errno::ENOENT => e
      raise e
    end
  
    private
  
    def self.request_parameters(file, parameters)
      required_parameters = { :import => 'image_data', :image_data => file, :returntype => 'text' }
      scrub_parameters(required_parameters.merge(parameters))
    end
  
    def self.scrub_parameters(parameters)
      scrubbed_parameters = {}
      parameters.each do |key, value| 
        scrubbed_parameters[parameter_key(key)] = value
      end
      scrubbed_parameters
    end
  
    def self.parameter_key(key)
      key = key.to_s
      PICNIK_API_PARAMETERS.include?(key) ? '_' + key : key
    end
    
    def self.image?(filename)
      MIME::Types.of(filename).first.media_type == 'image'
    end
    
    def self.api_key_in?(parameters)
      scrub_parameters(parameters).has_key?('_apikey')
    end
  end
end
