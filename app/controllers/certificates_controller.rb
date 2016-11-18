class CertificatesController < ApplicationController
  include Assignable

  assign :certificate
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

    if response.code != "200"
      flash[:error] = "Request to API failed"
      render :new
    end

    response_body = JSON.parse(response.body)

    certificate = Certificate.new(certificate_params)
    certificate.status_path = response_body["status_path"]
    certificate.identifier = /certificate_generation\/(.*)/.match(certificate.status_path)[1]


    if certificate.save
      flash[:success] = "Certificate saved!"
      redirect_to certificates_path
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

  def certificate_params
    params.require(:certificate).permit(:domain, :subdomains, :app_name, :debug)
  end

  def send_api_call(domain, subdomains, debug, app_name)

    # Set the ENV variables
    auth_token = ENV['AUTH_TOKEN']
    api_path = ENV['API_PATH']

    # Prepare the request
    uri = URI.parse(api_path +"#{domain}?subdomains=#{subdomains}&debug=#{debug}&auth_token=#{auth_token}&app_name=#{app_name}")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.initialize_http_header({"User-Agent" => "My Ruby Script"})

    # Call the API
    http.request(request)

  end

end
