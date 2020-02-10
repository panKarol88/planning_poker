class VotingService
  include RequestHelper
  include LoggerHelper
  attr_reader :vote

  def initialize(voter_name, host_name, points)
    create_vote voter_name, host_name, points
  end

  def vote
    @vote.validate!
    send_post('http://localhost:4567/api/v1/client/vote', @vote.body)
  rescue ActiveModel::ValidationError
    log_error(@vote.errors.full_messages)
  end

  private
  def create_vote(voter_name, host_name, points)
    @vote = Vote.new(voter_name, host_name, points)
  end
end
