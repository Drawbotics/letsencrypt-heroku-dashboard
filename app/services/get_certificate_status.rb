class GetCertificateStatus < ApplicationService
  attr_accessor :certificate

  def initialize(certificate, auth_token)
    @certificate = certificate
    @auth_token  = auth_token
  end

  API_PATH = ENV['API_PATH']
  def call
    raw_uri = @certificate.status_path
    response = SendRequest.new(raw_uri, "GET").call
    response_body = JSON.parse(response)
    @certificate.status = response_body['status']
    @certificate.status_errors = response_body['error']
    @certificate.message = response_body['message']
    @certificate.save

    self.certificate = @certificate
    return self
  end

end
	