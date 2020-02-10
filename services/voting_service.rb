class VotingService
  include RequestHelper

  def initialize(planning_session)
    @planning_session = planning_session
  end

  def vote(voter_name, host_name, points)
    send_post(
        'http://localhost:4567/api/v1/client/vote',
        {voter_name: voter_name, host_name: host_name, points: points})
  end
end

