class GetHerokuApps < ApplicationService

  HEROKU_BASE_URL = "https://api.heroku.com".freeze

  def initialize
    @headers = {
      "Accept" => 'application/vnd.heroku+json; version=3',
      "Authorization" => "Bearer #{ENV['HEROKU_OAUTH_KEY']}",
      "Content-Type" => "application/json"
    }
    @query = { enabled: true }.to_json
  end

  def call
    HTTParty.get("#{HEROKU_BASE_URL}/apps", headers: @headers, body: @query)
  end

end
