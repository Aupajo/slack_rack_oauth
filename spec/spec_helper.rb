require "bundler/setup"
require "slack_rack_oauth"

# Load all files in spec/support
Dir["#{__dir__}/support/**/*.rb"].each { |file| require file }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  # Use expect syntax
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Randomize test order
  config.order = :random

  # Generate a seed
  Kernel.srand config.seed
end
