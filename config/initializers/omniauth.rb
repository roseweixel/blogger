Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['github_client_id'], ENV['github_client_secret'], scope: "read:org"
end


# token: c45d3251546c41fb35a0daf78f36b8ebe35c5635
