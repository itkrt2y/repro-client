
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "repro/client/version"

Gem::Specification.new do |spec|
  spec.name          = "repro-client"
  spec.version       = Repro::Client::VERSION
  spec.authors       = ["Tatsuya Itakura"]
  spec.email         = ["itkrt2y.591721200@gmail.com"]
  spec.summary       = "Repro API Client"
  spec.homepage      = "https://github.com/itkrt2y/repro-client"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
