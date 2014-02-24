lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sidekiq/jfails/version'


Gem::Specification.new do |gem|
  # Authors
  gem.authors       = ["Andrei Ponomarenko"]
  gem.email         = ["biglolko@gmail.com"]
  # About gem
  gem.name          = "sidekiq-jfails"
  gem.version       = Sidekiq::Jfails::VERSION
  gem.description   = %q{Keep track of fails in Sidekiq jobs}
  gem.summary       = %q{Keeps track of fails in Sidekiq jobs in web and provides detailed information on the fail}
  gem.homepage      = "https://github.com/sjke/sidekiq-jfails/"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  # Dependencys
  gem.add_dependency "sidekiq", ">= 2.17.0"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rack-test"
  gem.add_development_dependency "sprockets"
  gem.add_development_dependency "sinatra"
end
