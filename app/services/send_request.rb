class SendRequest

  def initialize(raw_uri)
    @raw_uri = raw_uri
  end

  def call
    uri = URI.parse(@raw_uri)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    http.request(request)
  end
  
end
