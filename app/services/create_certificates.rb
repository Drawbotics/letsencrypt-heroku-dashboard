class CreateCertificates < ApplicationService
  attr_accessor :certificate

  def initialize(user, app_name, zone, domains, debug)
    self.success = false

    @user       = user
    @app_name   = app_name
    @zone     = zone
    @domains = domains
    @debug      = debug == "1" ? 1 : 0
  end

  def call

    if certificate = user_cert_for_app(@app_name)
      self.message = "You already have a certificate for this app."
      self.success = false
      self.certificate = certificate
      return self
    end

    response = send_api_call(@app_name, @zone, @domains, @debug)

    if response.code != '200'
      self.message = "Request to API failed."
      self.success = false
      return self
    end

    response_body = JSON.parse(response.body)
    certificate = @user.certificates.build(user: @user, app_name: @app_name, zone: @zone, domains: @domains, debug: @debug)
    certificate.status_path = response_body['url']
    certificate.identifier = response_body['uuid']
    if certificate.save
      self.message = 'Certificate saved!'
      self.success = true
      self.certificate = certificate
      return self
    else
      self.message = certificate.errors.full_messages.to_sentence
      self.success = false
      return self
    end

  end

  private

  API_PATH = ENV['API_PATH']

  def send_api_call(app_name, zone, domains, debug)  
    params = {
      zone: zone,
      domains: domains,
      debug: debug,
      auth_token: auth_token,
      heroku_app_name: app_name,
      auth_token: ENV['AUTH_TOKEN'],
      cloudflare_email: ENV['CLOUDFLARE_EMAIL'],
      cloudflare_api_key: ENV['CLOUDFLARE_API_KEY'],
      heroku_oauth_token: ENV['HEROKU_OAUTH_KEY']
    }
    raw_uri = "#{API_PATH}/certificate_request"
    Rails.logger.info "POST to #{raw_uri}"
    Rails.logger.info "POST for #{params}"
    SendRequest.new(raw_uri, "POST", params).call
  end

  def user_cert_for_app(app_name)
    @user.certificates.find_by(app_name: app_name)
  end

  def auth_token
    @user.auth_token
  end

end
