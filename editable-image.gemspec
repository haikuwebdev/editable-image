Gem::Specification.new do |s|
  s.name = 'editable-image'
  s.version = '0.2'
  s.summary = 'Simplified interface to web-based image editors.'
  s.authors = ['TJ Stankus']
  s.email = 'tj@haikuwebdev.com'
  s.homepage = 'http://github.com/haikuwebdev/editable-image/'
  s.has_rdoc = false
  s.files = ['README', 'editable-image.gemspec', 'lib/multipart.rb', 'lib/picnik.rb', 'test/picnik_test.rb', 'test/files/logo.gif']
  s.add_dependency('mime-types', '>= 1.15')
  s.add_dependency('Shoulda', '>= 1.1.1')
end
