require 'uri'
require 'net/http'
require 'json'

module SlackRackOAuth
  class Middleware
    attr_reader :app, :client_id, :client_secret, :path, :scopes

    def initialize(app, scopes:, client_id: ENV.fetch('SLACK_CLIENT_ID'), client_secret: ENV.fetch('SLACK_CLIENT_SECRET'), path: '/slack/oauth')
      @client_id = client_id
      @client_secret = client_secret
      @app = app
      @scopes = Array(scopes)
      @path = path
    end

    def call(env)
      if env['PATH_INFO'] == "#{path}/authorize"
        return redirect_to_authorization_url(
          scheme: env['rack.url_scheme'],
          host: env['HTTP_HOST']
        )
      end

      if env['PATH_INFO'] == "#{path}/callback"
        code = Rack::Request.new(env).params['code']

        response = Net::HTTP.post_form(URI("https://slack.com/api/oauth.access"),
          'client_id' => client_id,
          'client_secret' => client_secret,
          'code' => code,
          'redirect_uri' => redirect_uri(
            scheme: env['rack.url_scheme'],
            host: env['HTTP_HOST']
          )
        )

        env['slack.auth'] = JSON.parse(response.body)
      end

      app.call(env)
    end

    private

    def redirect_to_authorization_url(*args)
      [302, { 'Location' => authorization_url(*args) }, []]
    end

    def redirect_uri(scheme:, host:)
      "#{scheme}://#{host}#{path}/callback"
    end

    def authorization_url(*args)
      params = URI.encode_www_form(
        scope: scopes.join(','),
        client_id: client_id,
        redirect_uri: redirect_uri(*args)
      )

      "https://slack.com/oauth/authorize?#{params}"
    end
  end
end
