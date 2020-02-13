class PlanningSessionService
  include RequestHelper
  include LoggerHelper
  include StorageHelper
  include DisplayHelper
  include PlanningHelper
  attr_reader :planning_session, :vote_count, :result, :listener

  def initialize(voters_count, host_name)
    create_planning_session voters_count, host_name
    @listener = nil
  end

  def proceed(override=false)
    @planning_session.validate!
    start_poker override
  rescue ActiveModel::ValidationError
    log_error(@planning_session.errors.full_messages)
  end

  def restart
    @listener.terminate if @listener.present?
    if stored_planning(@planning_session.host_name).blank?
      show_text 'There is nothing to repeat.'
      return
    end
    note_all_voters(@planning_session.host_name,
                    voting_statuses[:restarted],
                    'Voting has been restarted. Please vote again.')
    proceed true
  end

  def end_planning(reason=nil)
    note_all_voters(@planning_session.host_name,
                    voting_statuses[:ended],
                    reason || 'Voting has been closed by the host.')
    show_text reason if reason.present?
    delete_planning @planning_session.host_name
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
        if message['event'].present?
          case message['event']
          when voting_statuses[:successful_vote]
            print_progress @planning_session.host_name
          when voting_statuses[:voters_max_reached]
            print_progress @planning_session.host_name
            print_results @planning_session.host_name, true
            planning = stored_planning @planning_session.host_name
            final_score = count_result(planning['voters'])
            if final_score != 'DRAW'
              # TODO
              sleep(3)
              end_planning "Voting ends with final score: #{final_score}"
            end
          when voting_statuses[:restarted]
            @listener.terminate if @listener.present?
          when voting_statuses[:ended]
            show_text message['text']
            @listener.terminate if @listener.present?
          end
        else
          puts message
        end
      end
    end
  end

  def close
    @listener.terminate if @listener.present?
    send_get("stream/unsubscribe/#{@planning_session.host_name}")
  end

  def start
    url = "stream/subscribe/#{@planning_session.host_name}/#{@planning_session.host_name}"
    open_stream(url, progress_handler)
  end

  def start_poker(override=false)
    if override || stored_planning(@planning_session.host_name).blank?
      show_progress 0, @planning_session.voters_count
      upload_planning @planning_session.host_name, @planning_session.init_structure.to_json
      @listener = Thread.new do
        start
      end
    else
      show_text "Voting for the host - #{@planning_session.host_name} is pending yet. \n"
      show_text "Type 'poker repeat' if you want to start over or 'poker end' to terminate."
      return
    end
  end
end
