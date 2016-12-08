class GetCertificateStatus < ApplicationService
  attr_accessor :certificate

  def initialize(certificate, auth_token)
    @certificate = certificate
    @auth_token  = auth_token
  end

  API_PATH = ENV['API_PATH']
  def call
    raw_uri = "#{API_PATH}/certificate_generation/#{@certificate.identifier}?auth_token=#{@auth_token}"
    response = SendRequest.new(raw_uri).call
    if response.code == '200'
      response_body = JSON.parse(response.body)
      @certificate.status = response_body['status']
      @certificate.status_errors = response_body['error']
      @certificate.message = response_body['message']
      @certificate.save
    end
    self.certificate = @certificate
    return self
  end

end
