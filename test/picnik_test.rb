require File.dirname(__FILE__) + '/../lib/editable-image'
require 'test/unit'
require 'shoulda'


class PicnikTest < Test::Unit::TestCase

  context "Request parameters" do
    setup do
      EditableImage::Picnik.class_eval do
        def self.public_request_parameters(*args)
          request_parameters(*args)
        end
      end
      @file = File.open("files/logo.gif")
      parameters = {:apikey => 'test_picnik_apikey'}
      @request_parameters = EditableImage::Picnik.public_request_parameters(@file, parameters)
    end
    
    teardown do
      @file.close
    end
    
    should "include _import" do
      assert @request_parameters.keys.include?('_import')
    end
  
    should "have correct value for _import" do
      assert_equal 'image_data', @request_parameters['_import']
    end
    
    should "include image_data" do
      assert @request_parameters.keys.include?('image_data')
    end
    
    should "not have nil image_data" do
      assert_not_nil @request_parameters['image_data']
    end
    
    should "include _returntype" do
      assert @request_parameters.keys.include?('_returntype')
    end
    
    should "have returntype of text" do
      assert_equal 'text', @request_parameters['_returntype']
    end
    
  end
  
  context "Parameter key" do
    setup do
      EditableImage::Picnik.class_eval do
        def self.public_parameter_key(*args)
          parameter_key(*args)
        end
      end
    end
  
    should "be stringified" do
      assert_equal 'foo', EditableImage::Picnik.public_parameter_key(:foo)
    end
  
    should "add underscore for Picnik API parameter" do
      assert_equal '_apikey', EditableImage::Picnik.public_parameter_key(:apikey)
    end
  
    should "not add underscore for non-Picnik API parameter" do
      assert_equal 'foo', EditableImage::Picnik.public_parameter_key('foo')
    end
  
    should "not add underscore for Picnik API parameter that already has one" do
      assert_equal '_apikey', EditableImage::Picnik.public_parameter_key('_apikey')
    end
  
    should "keep underscore for non Picnik API parameter" do
      assert_equal '_method', EditableImage::Picnik.public_parameter_key('_method')
    end
  end
  
  context "A bad filename" do
    setup do 
      @filename = 'bad_filename'
      @parameters = {:apikey => 'test'}
    end
    
    should "raise EditableImage::InvalidFilenameError exception" do
      assert_raise(EditableImage::InvalidFilenameError) do 
        EditableImage::Picnik.url(@filename, @parameters)
      end
    end
    
    should "have exception message containing 'no such file'" do
      begin
        EditableImage::Picnik.url(@filename, @parameters)
      rescue EditableImage::InvalidFilenameError => e
        assert_match /no such file/i, e.message
      end
    end
  end
  
  context "A non-image file" do
    setup do
      @non_image_filename = File.expand_path("files/test.txt")
      @parameters = {:apikey => 'test'}
    end
    
    should "raise EditableImage::InvalidFileTypeError exception" do
      assert_raise(EditableImage::InvalidFileTypeError)  do
        EditableImage::Picnik.url(@non_image_filename, @parameters)
      end
    end
    
    should "have exception message containing 'foo'" do
      begin
        EditableImage::Picnik.url(@non_image_filename, @parameters)
      rescue EditableImage::InvalidFileTypeError => e
        assert_match /must be an image/i, e.message
      end
    end
  end
  
  context "A request for url without apikey in parameters" do
    
    should "raise EditableImage::InvalidParametersError" do
      assert_raise(EditableImage::InvalidParametersError) do
        EditableImage::Picnik.url('some_filename', {})
      end
    end
    
    should "raise EditableImage::InvalidParametersError exception with message containing 'must include the apikey'" do
      begin
        EditableImage::Picnik.url('some_filename', {})
      rescue EditableImage::InvalidParametersError => e
        assert_match /must include the apikey/i, e.message
      end
    end
    
  end

end