RSpec.describe SlackRackOAuth do
  it "redirects to the OAuth URL with the appropriate client ID and scopes" do
    configure_middleware!(client_id: '42', scopes: ['bot', 'incoming-webhook'])

    get('/slack/oauth/authorize')
    
    expect(last_response.status).to be 302
    expect(last_response.location)
      .to eq 'https://slack.com/oauth/authorize?scope=bot%2Cincoming-webhook&client_id=42&redirect_uri=http%3A%2F%2Fexample.org%2Fslack%2Foauth%2Fcallback'
  end
  
  it "does not touch unsupported routes" do
    get('/slack/oauth/unsupported')
    expect(last_response.body).to eq 'Underlying app'
  end
  
  it "does not touch unsupported routes" do
    get('/slack/oauth/unsupported')
    expect(last_response.body).to eq 'Underlying app'
  end
end
