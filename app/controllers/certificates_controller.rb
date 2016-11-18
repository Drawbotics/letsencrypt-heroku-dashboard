class CertificatesController < ApplicationController
  include Assignable

  assign :certificate
  def new
    @certificate = Certificate.new
  end

  def create
    certificate = Certificate.new(certificate_params)
    if certificate.save
      flash[:success] = "Certificate saved!"
      render :index
    else
      flash[:error] = "Certificate not saved!"
      render :new
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

end
