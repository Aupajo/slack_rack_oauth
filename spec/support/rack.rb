require "rack"
require "rack/test"

RSpec.configure do |config|
  # Enables support for `get`, `last_response`, etc.
  config.include Rack::Test::Methods
end
