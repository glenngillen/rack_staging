Gem::Specification.new do |s|
  s.version = '0.1.0'
  s.name = "rack_staging"
  s.files = ["README.mdown", "Rakefile"]
  s.files += Dir["lib/**/*.rb","test/**/*"]
  s.summary = "Rack::Staging - Protects your staging apps from prying eyes."
  s.description = "Automatically protects your staging app from web crawlers and casual visitors."
  s.email = "me@glenngillen.com"
  s.homepage = "http://github.com/glenngillen/rack_staging"
  s.authors = ["Glenn Gillen"]
  s.test_files = Dir["test/**/*"]
  s.require_paths = [".", "lib"]
  s.has_rdoc = 'false'

  if s.respond_to? :specification_version
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2
  end
end
