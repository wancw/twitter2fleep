lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twitter2fleep/version'

Gem::Specification.new do |s|
  s.name        = 'twitter2fleep'
  s.version     = Twitter2Fleep::VERSION
  s.date        = '2014-04-23'
  s.summary     = 'Twitter to Fleep'
  s.description = 'Forward tweets to Fleep.io conversation.'
  s.authors     = ["WanCW"]
  s.email       = 'wancw.wang@gmail.com'
  s.files       = []
  s.homepage    = 'http://github.com/wancw/twitter2fleep'
  s.executables << 'twitter2fleep'
  s.license     = 'MIT'

  s.add_dependency 'twitter', '~> 5.8.0'
  s.add_dependency 'thor', '~> 0.19.1'
end