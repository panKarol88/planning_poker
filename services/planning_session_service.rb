class PlanningSessionService
  include RequestHelper
  include LoggerHelper
  include StorageHelper
  include DisplayHelper
  attr_reader :planning_session, :vote_count, :result

  def initialize(voters_count, host_name)
    create_planning_session voters_count, host_name
    @@vote_count = 0
    @@planning_results = []
    @result = nil
  end

  def proceed
    @planning_session.validate!
    start_poker
  rescue ActiveModel::ValidationError
    log_error(@planning_session.errors.full_messages)
  end

  def restart
    note_all_voters({ text: 'Voting has been restarted. Please vote again.'})
    close
    proceed
  end

  def end_planning
    note_all_voters({ text: 'Voting has been closed by the host.'})
    close
  end

  private

  def create_planning_session(voters_count, host_name)
    @planning_session = PlanningSession.new(voters_count, host_name)
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
            print_progress @planning_session.host_name
          when 'voters_max_reached'
            print_results @planning_session.host_name
          end
        else
          puts message
        end
      end
    end
  end

  def note_all_about_progress
    note_all_voters({ progress: { vote_count: @@vote_count, voters_count: @planning_session.voters_count }})
  end

  def handle_text(text)
    DisplayService.new().show_text(text)
  end

  def note_all_voters(body)
    body[:host_name] = @planning_session.host_name
    body[:recipient] = 'all'
    send_post('http://localhost:4567/api/v1/client/push', body)
  end

  def close
    url = "http://localhost:4567/stream/v1/host/unsubscribe/#{@planning_session.host_name}"
    send_get(url)
  end

  def start
    url = "http://localhost:4567/api/v1/stream/subscribe/#{@planning_session.host_name}/#{@planning_session.host_name}"
    open_stream(url, progress_handler)
  end

  def start_poker
    show_progress(0, @planning_session.voters_count)
    r_set @planning_session.host_name, @planning_session.init_structure.to_json
    Thread.new do
      start
    end
  end
end
