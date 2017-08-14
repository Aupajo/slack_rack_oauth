module MiddlewareTestHelpers
  BARE_RACK_APP = -> (env) { [200, {}, ['Underlying app']] }
  
  def configure_middleware!(client_secret: 'secret', client_id: 'id', scopes: 'bot', **options)
    @app = Rack::Builder.new do
      use SlackRackOAuth, options.merge(
        scopes: scopes,
        client_secret: client_secret,
        client_id: client_id
      )

      run BARE_RACK_APP
    end
  end

  # An `app` method is required for Rack::Test::Methods to work
  def app
    @app || configure_middleware!
  end
end

RSpec.configure do |config|
  config.include MiddlewareTestHelpers
end
