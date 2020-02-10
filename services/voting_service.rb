class VotingService
  def initialize(planning_session)
    @planning_session = planning_session
  end

  def start
    uri = URI("http://localhost:4567/api/v1/host/subscribe/#{@planning_session.host_name}")

    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Get.new uri
      vote_count = 0

      http.request request do |response|
        response.read_body do |chunk|
          message = JSON.parse chunk if chunk.present?
          puts message
          DisplayService.new().show_progress(vote_count, @planning_session.voters_count)
          vote_count += 1
        end
      end
    end
  end

  def self.vote(voter_name, host_name, points)
    uri = URI('http://localhost:4567/api/v1/client/vote')
    req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    req.body = {voter_name: voter_name, host_name: host_name, points: points}.to_json

    Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request req
    end
    'voted'
  end
end
