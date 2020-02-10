module RequestHelper
  def send_post(url, body={})
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path)
    request.body = body.to_json
    http.request(request)
  end

  def open_stream(url, progress_handler)
    uri = URI(url)
    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Get.new uri
      http.request request do |response|
        response.read_body do |chunk|
          progress_handler.call(chunk)
        end
      end
    end
  end
end
