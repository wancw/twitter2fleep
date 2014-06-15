lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twitter2fleep/version'

Gem::Specification.new do |spec|
  spec.name        = 'twitter2fleep'
  spec.version     = Twitter2Fleep::VERSION
  spec.license     = 'MIT'

  spec.summary     = 'Twitter to Fleep'
  spec.description = 'Forward tweets to Fleep.io conversation.'

  spec.homepage    = 'http://github.com/wancw/twitter2fleep'

  spec.author      = 'WanCW'
  spec.email       = 'wancw.wang@gmail.com'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'twitter', '~> 5.8.0'
  spec.add_dependency 'thor', '~> 0.19.1'
end