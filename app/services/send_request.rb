class SendRequest

  def initialize(raw_uri, verb, params = nil)
    @raw_uri = raw_uri
    @verb = verb
    @params = params
  end

  def call
    uri = URI.parse(@raw_uri)
    http = Net::HTTP.new(uri.host, uri.port)
    response = make_request_from_http_verb(@verb, uri)
  end

  private

  def make_request_from_http_verb(verb, uri)
    case verb
      when 'GET' then request = make_get_request(uri)
      when 'POST' then request = make_post_request(uri)
      else request = make_get_request(uri)
    end
    return request
  end

  def make_get_request(uri)
    uri.query = URI.encode_www_form(@params) if @params
    Net::HTTP.get(uri)
  end

  def make_post_request(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    header = {'Content-Type': 'text/json'}
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = @params.to_json
    http.request(request)
  end
  
end
