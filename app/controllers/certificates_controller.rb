class CertificatesController < ApplicationController
  before_filter :authorize

  include Assignable
  assign :certificate

  def show
    raw_certificate = Certificate.find(params[:id])
    @certificate = raw_certificate.status_path ? update_certificate(raw_certificate) : raw_certificate
  end

  def new
    response = GetHerokuApps.call
    @app_names = response.map{ |app| app['name'] }
    @certificate = Certificate.new
  end

  def create

    app_name   = certificate_params[:app_name]
    domain     = certificate_params[:domain]
    subdomains = certificate_params[:subdomains]
    debug      = certificate_params[:debug]

    service = CreateCertificates.call(current_user, app_name, domain, subdomains, debug)

    if service.success?
      flash[:success] = service.message
      redirect_to service.certificate
    else
      flash[:error] = service.message
      # If there a certificate already exist, then redirect to this one, otherwise a new one
      redirect_to service.certificate ? service.certificate : new_certificate_path
    end

  end

  assign :certificates
  def index
    @certificates = Certificate.all.order(:id)
  end

  private

  def certificate_params
    params.require(:certificate).permit(:domain, :subdomains, :app_name, :debug)
  end

  API_PATH = ENV['API_PATH']

  def update_certificate(certificate)
    raw_uri = "#{API_PATH}/certificate_generation/#{certificate.identifier}?auth_token=#{auth_token}"
    response = SendRequest.new(raw_uri).call
    if response.code == '200'
      response_body = JSON.parse(response.body)
      certificate.status = response_body['status']
      certificate.status_errors = response_body['error']
      certificate.message = response_body['message']
      certificate.tap(&:save)
    end
    certificate
  end


end
