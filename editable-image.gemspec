Gem::Specification.new do |spec|
  spec.name = 'editable-image'
  spec.version = '0.12'
  spec.summary = "Interface to web-based image editors."
  spec.authors = 'TJ Stankus'
  spec.email = 'tj@haikuwebdev.com'
  spec.homepage = 'http://github.com/haikuwebdev/editable-image/'
  spec.has_rdoc = false
  spec.files = ['README', 'lib/multipart.rb', 'lib/picnik.rb']
  spec.test_files = ['test/picnik_test.rb']
  spec.add_dependency 'mime-types', '>= 1.15'
  spec.add_dependency 'Shoulda'
end
