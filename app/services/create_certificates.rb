class CreateCertificates < ApplicationService
  attr_accessor :certificate

  def initialize(user, app_name, domain, subdomains, debug)
    self.success = false

    @user       = user
    @app_name   = app_name
    @domain     = domain
    @subdomains = subdomains
    @debug      = debug ? 1 : 0
  end

  def call

    if certificate = user_cert_for_app(@app_name)
      self.message = "You already have a certificate for this app."
      self.success = false
      self.certificate = certificate
      return self
    end

    response = send_api_call(@app_name, @domain, @subdomains, @debug)

    if response.code != '200'
      self.message = "Request to API failed."
      self.success = false
      return self
    end

    response_body = JSON.parse(response.body)
    certificate = @user.certificates.build(user: @user, app_name: @app_name, domain: @domain, subdomains: @subdomains, debug: @debug)
    certificate.status_path = response_body['status_path']
    certificate.identifier = /certificate_generation\/(.*)/.match(certificate.status_path)[1]

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

  def send_api_call(domain, subdomains, debug, app_name)
    raw_uri = "#{API_PATH}/certificate_generation/new/#{domain}?subdomains=#{subdomains}&debug=#{debug}&auth_token=#{auth_token}&app_name=#{app_name}"
    SendRequest.new(raw_uri).call
  end

  def user_cert_for_app(app_name)
    @user.certificates.find_by(app_name: app_name)
  end

  def auth_token
    @user.auth_token
  end

end
