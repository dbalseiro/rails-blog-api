Devise.setup do |config|
  config.navigational_formats = [:json]
  config.omniauth :github, 
                  ENV['GITHUB_KEY'], 
                  ENV['GITHUB_SECRET'], 
                  scope: 'email,profile'
end
