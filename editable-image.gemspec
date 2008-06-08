Gem::Specification.new do |s|
  s.name = "editable-image"
  s.version = "0.21"
  s.summary = "Simplified interface to web-based image editors."
  s.email = "tj@haikuwebdev.com"
  s.homepage = "http://github.com/haikuwebdev/editable-image/"
  s.description = "Simplified interface to web-based image editors."
  s.has_rdoc = false
  s.authors = ["TJ Stankus"]
  s.files = ["README", "editable-image.gemspec", "lib/multipart.rb", "lib/picnik.rb"]
  s.test_files = ["test/picnik_test.rb", "test/files/logo.gif"]
  s.add_dependency("mime-types", [">= 1.15"])
  s.add_dependency("Shoulda", [">= 1.1.1"])
end
