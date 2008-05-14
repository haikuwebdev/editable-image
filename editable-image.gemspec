Gem::Specification.new do |spec|
  spec.name = 'editable-image'
  spec.version = '0.1'
  spec.summary = "Interface to web-based image editors."
  spec.author = 'TJ Stankus'
  spec.email = 'tj@haikuwebdev.com'
  spec.homepage = 'http://github.com/haikuwebdev/editable-image/'
  # spec.rdoc = true
  spec.files = Dir['lib/**/*.rb'] + Dir['test/**/*']
  spec.add_dependency 'mime-types', '>= 1.15'
  spec.add_dependency 'Shoulda'
end
