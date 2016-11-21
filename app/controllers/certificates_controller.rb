class CertificatesController < ApplicationController
  before_filter :authorize

  include Assignable
  assign :certificate

  def show
    raw_certificate = Certificate.find(params[:id])
    @certificate = raw_certificate.status_path ? update_certificate(raw_certificate) : raw_certificate
  end

  def new
    @certificate = Certificate.new
  end

  def create

    response = send_api_call(
      certificate_params[:domain],
      certificate_params[:subdomains],
      certificate_params[:debug] ? 1 : 0,
      certificate_params[:app_name]
    )

    if response.code != '200'
      flash[:error] = "Request to API failed"
      render :new
    end

    response_body = JSON.parse(response.body)


    certificate = Certificate.new(certificate_params)
    certificate.status_path = response_body['status_path']
    certificate.identifier = /certificate_generation\/(.*)/.match(certificate.status_path)[1]


    if certificate.save
      flash[:success] = 'Certificate saved!'
      redirect_to certificate_path(certificate)
    else
      flash.now[:error] = certificate.errors.full_messages.to_sentence
      render 'new'
    end
  end

  assign :certificates
  def index
    @certificates = Certificate.all.order(:id)
  end

  private

  def auth_token
    current_user.auth_token
  end

  API_PATH = ENV['API_PATH']

  def certificate_params
    params.require(:certificate).permit(:domain, :subdomains, :app_name, :debug)
  end

  def update_certificate(certificate)
    raw_uri = "#{API_PATH}/certificate_generation/#{certificate.identifier}?auth_token=#{auth_token}"
    response = send_request(raw_uri)
    if response.code == '200'
      response_body = JSON.parse(response.body)
      certificate.status = response_body['status']
      certificate.status_errors = response_body['error']
      certificate.message = response_body['message']
      certificate.tap(&:save)
    end
    certificate
  end

  def send_api_call(domain, subdomains, debug, app_name)
    raw_uri = "#{API_PATH}/certificate_generation/new/#{domain}?subdomains=#{subdomains}&debug=#{debug}&auth_token=#{auth_token}&app_name=#{app_name}"
    send_request(raw_uri)
  end

  def send_request(raw_uri)
    uri = URI.parse(raw_uri)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    http.request(request)
  end


end
