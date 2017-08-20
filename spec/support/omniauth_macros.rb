# frozen_string_literal: true

module OmniauthMacros
  def mock_facebook_auth_hash
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      provider: 'facebook', uid: '1235456',
      info: { name: 'Ivan', image: 'my_image_url', email: 'admin@example.com' },
      credentials: { token: 'my_facebook_token' }
    )
  end

  def mock_twitter_auth_hash
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
      provider: 'twitter', uid: '1235456',
      info: { name: 'Ivan', image: 'my_image_url' },
      credentials: { token: 'my_twitter_token', secret: 'my_twitter_secret' }
    )
  end
end
