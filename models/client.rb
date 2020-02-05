require 'httparty'

class Client
  def self.vote(points)
    response = HTTParty.get('http://localhost:4567/api/v1/host/create_session')
    puts response.body, response.code

    response.body
  end
end
