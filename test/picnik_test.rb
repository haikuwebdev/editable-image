require File.dirname(__FILE__) + '/../lib/editable-image'
require 'test/unit'
require 'shoulda'


class PicnikTest < Test::Unit::TestCase

  # TODO:
  # - Test unexpected response from Picnik with a mock
  # - Test expected response from Picnik with a mock.

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
  
  context "A file" do
    context "that does not exist" do
      should "raise an exception" do
        assert_raise(Errno::ENOENT)  { EditableImage::Picnik.url('bad_filename', {:apikey => 'test'}) }
      end
    end
    
    context "that is not an image" do
      should "raise an exception" do
        @non_image_filename = File.expand_path("files/test.txt")
        assert_raise(EditableImage::InvalidFileTypeError)  do
          EditableImage::Picnik.url(@non_image_filename, {:apikey => 'test'})
        end
      end
    end
  end
  
  context "The apikey" do
    setup do
      @full_filename = File.expand_path("files/logo.gif")
    end
    
    should "be passed in parameters" do
      assert_raise(EditableImage::InvalidParametersError) do
        EditableImage::Picnik.url(@full_filename, {})
      end
    end
  end
  
end