require "slack_rack_oauth/version"
require "slack_rack_oauth/middleware"

module SlackRackOAuth
  module_function

  # Defining `new` here allows us to simply write `use SlackRackOAuth`.
  def new(*args)
    Middleware.new(*args)
  end
end
