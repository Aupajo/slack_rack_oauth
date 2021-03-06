# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "slack_rack_oauth/version"

Gem::Specification.new do |spec|
  spec.name          = "slack_rack_oauth"
  spec.version       = SlackRackOAuth::VERSION
  spec.authors       = ["Pete Nicholls"]
  spec.email         = ["aupajo@gmail.com"]

  spec.summary       = %q{Simple Rack middleware for handling Slack's “Add to Slack” button OAuth flow.}
  spec.homepage      = "https://github.com/Aupajo/slack_rack_oauth"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rack"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rack-test", "~>0.6.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.0"
end
