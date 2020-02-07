class Planning
  def self.start
    uri = URI('http://localhost:4567/api/v1/host/subscribe')

    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Get.new uri

      http.request request do |response|
        response.read_body do |chunk|
          p chunk
        end
      end
    end
  end

  def self.join
    Thread.new do
      uri = URI('http://localhost:4567/api/v1/host/subscribe')

      Net::HTTP.start(uri.host, uri.port) do |http|
        request = Net::HTTP::Get.new uri

        http.request request do |response|
          response.read_body do |chunk|
            p chunk
          end
        end
      end
    end
    'joined'
  end

  def self.vote(points)
    options = {
        :body => 'body'
    }

    Net::HTTP.post URI('http://localhost:4567/api/v1/host/aaa'),
                   options.to_json,
                   'Content-Type' => 'application/json'

    'voted'
  end
end
