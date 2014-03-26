# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'word_counter/version'

Gem::Specification.new do |spec|
  spec.name          = "word_counter"
  spec.version       = WordCounter::VERSION
  spec.authors       = ["trevor bortins"]
  spec.email         = ["trevor.bortins@gmail.com"]
  spec.summary       = %q{Counts words in a file and prints them out in interesting ways.}
  spec.description   = %q{Counts words in a file and prints them out in interesting ways.}
  spec.homepage      = "https://github.com/wulftone/word_counter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry-debugger"

  spec.add_dependency "nokogiri"
end
