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
        return redirect_to_authorization_url
      end

      if env['PATH_INFO'] == "#{path}/callback"
        fail "TODO"
        env['slack.auth'] = {}
      end

      app.call(env)
    end

    private

    def redirect_to_authorization_url
      [302, { 'Location' => authorization_url }, []]
    end

    def authorization_url
      "https://slack.com/oauth/authorize?scope=#{scopes.join(',')}&client_id=#{client_id}"
    end
  end
end
