module RequestHelper
  def server_address
    ENV['SERVER_ADDRESS'] || 'localhost'
  end

  def port
    ENV['PORT'] || '4567'
  end

  def api
    ENV['API'] || 'v1'
  end

  def req_uri(url)
    URI("http://#{server_address}:#{port}/api/#{api}/#{url}")
  end

  def send_post(url, body={})
    uri = req_uri(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path)
    request.body = body.to_json
    http.request(request)
  end

  def send_get(url)
    uri = req_uri(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.path)
    http.request(request)
  end

  def send_delete(url)
    uri = req_uri(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Delete.new(uri.path)
    http.request(request)
  end

  def open_stream(url, progress_handler)
    uri = req_uri(url)
    Net::HTTP.start(uri.host, uri.port, { read_timeout: 600, open_timeout: 5 }) do |http|
      request = Net::HTTP::Get.new uri
      http.request request do |response|
        response.read_body do |chunk|
          progress_handler.call(chunk)
        end
      end
    end
  end
end
