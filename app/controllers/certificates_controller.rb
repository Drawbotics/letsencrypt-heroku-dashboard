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

  def update_certificate(certificate)
    service = GetCertificateStatus.call(certificate, @user.auth_token)
    service.certificate
  end

end
