RSpec.describe SlackRackOAuth do
  it "redirects to the OAuth URL with the appropriate client ID and scopes" do
    configure_middleware!(client_id: '42', scopes: ['bot', 'incoming-webhook'])

    get('/slack/oauth/authorize')

    expect(last_response.status).to be 302
    expect(last_response.location)
      .to eq 'https://slack.com/oauth/authorize?scope=bot%2Cincoming-webhook&client_id=42&redirect_uri=http%3A%2F%2Fexample.org%2Fslack%2Foauth%2Fcallback'
  end

  it "handles the callback" do
    middleware = build_middleware(
      scopes: ['identify', 'bot'],
      client_secret: 'shh',
      client_id: 42
    )

    successful_response = <<~JSON
      {
        "ok": true,
        "access_token": "user-access-token",
        "scope": "identify,bot",
        "user_id": "U123ABC",
        "team_name": "Clarion",
        "team_id": "T456DEF",
        "bot": {
          "bot_user_id": "U789GHI",
          "bot_access_token": "bot-access-token"
        }
      }
    JSON

    stub_request(:post, "https://slack.com/api/oauth.access")
      .with(body: {
          "client_id" => "42",
          "client_secret" => "shh",
          "code" => "valid",
          "redirect_uri" => "http://example.org/slack/oauth/callback"
        })
        .to_return(status: 200, body: successful_response)

    request = build_request('/slack/oauth/callback?code=valid')
    middleware.call(request)

    expect(request['slack.auth']).to eq(
      "ok" => true,
      "access_token" => "user-access-token",
      "scope" => "identify,bot",
      "user_id" => "U123ABC",
      "team_name" => "Clarion",
      "team_id" => "T456DEF",
      "bot" => {
        "bot_user_id" => "U789GHI",
        "bot_access_token" => "bot-access-token"
      }
    )
  end

  it 'sets errors in the callback' do
    middleware = build_middleware

    error_response = '{"ok":false,"error":"code_already_used"}'

    stub_request(:post, "https://slack.com/api/oauth.access")
        .to_return(status: 200, body: error_response)

    request = build_request('/slack/oauth/callback?code=valid')
    middleware.call(request)

    expect(request['slack.auth']).to eq(
      "ok" => false,
      "error" => "code_already_used"
    )
  end

  it "does not touch other routes" do
    get('/slack/oauth/undefined')
    expect(last_response.body).to eq 'Underlying app'
  end
end
