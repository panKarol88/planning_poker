class VotingService
  include RequestHelper
  include LoggerHelper
  include StorageHelper
  include DisplayHelper
  include PlanningHelper
  attr_reader :vote, :listener

  def initialize(voter_name, host_name, points)
    create_vote voter_name, host_name, points
    @listener = nil
  end

  def vote
    @vote.validate!

    @listener = Thread.new do
      url = "http://localhost:4567/api/v1/stream/subscribe/karol/#{@vote.voter_name}"
      open_stream(url, progress_handler)
    end

    response = send_post('http://localhost:4567/api/v1/client/vote', @vote.body)
    handle_response response
  rescue ActiveModel::ValidationError
    log_error(@vote.errors.full_messages)
  end

  private

  def create_vote(voter_name, host_name, points)
    @vote = Vote.new(voter_name, host_name, points)
  end

  def handle_response(response)
    unless response.code == '200'
      show_text("Something went wrong with this vote.
                    Host: #{@vote.host_name}, Code: #{response.code}, Message: #{response.message}")
      @listener.terminate if @listener.present?
    end

    body = JSON.parse response.body if response.body.present?
    case body['status']
    when voting_statuses[:successful_vote]
      print_progress @vote.host_name
    when voting_statuses[:no_such_planning]
      show_text("There is not palnning for the host: #{@vote.host_name}")
    when voting_statuses[:already_voted]
      show_text('You already voted.')
    when voting_statuses[:unsuccessful_vote]
      show_text('Something went wrong. Your vote was unsuccessful.')
    when voting_statuses[:too_many_voters_already]
      show_text('Bummer ... team already voted :(')
    when voting_statuses[:voters_max_reached]
      print_results @vote.host_name
    end
  end

  def progress_handler
    Proc.new do |chunk|
      if chunk.present?
        message = JSON.parse chunk
        case
        when message['text'].present?
          handle_text message['text']
        when message['event'].present?
          case message['event']
          when 'successful_vote'
            print_progress @vote.host_name
          end
        else
          puts message
        end
      end
    end
  end
end
