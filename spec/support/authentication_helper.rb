# frozen_string_literal: true

module AuthenticationHelper
  def login(user)
    post user_session_path,
         params: {
           email: user.email,
           password: 'password'
         }.to_json,
         headers: {
           'CONTENT_TYPE' => 'application/json',
           'ACCEPT' => 'application/json'
         }
  end

  def get_auth_headers
    {
      'access-token' => response.headers['access-token'],
      'client' => response.headers['client'],
      'uid' => response.headers['uid'],
      'expiry' => response.headers['expiry'],
      'token_type' => response.headers['token_type']
    }
  end

  # This is the good one
  def auth_headers_for(user)
    user.create_new_auth_token
  end
end
