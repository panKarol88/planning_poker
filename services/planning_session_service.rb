class PlanningSessionService
  include RequestHelper
  include LoggerHelper
  attr_reader :planning_session, :vote_count

  def initialize(voters_count, host_name)
    create_planning_session voters_count, host_name
    @@vote_count = 0
  end

  def proceed
    @planning_session.validate!
    start_poker
  rescue ActiveModel::ValidationError
    log_error(@planning_session.errors.full_messages)
  end

  private

  def create_planning_session(voters_count, host_name)
    @planning_session = PlanningSession.new(voters_count, host_name)
  end

  def display_message
    Proc.new do |chunk|
      message = JSON.parse chunk if chunk.present?
      puts message
      DisplayService.new().show_progress(@@vote_count, @planning_session.voters_count)
      @@vote_count += 1
    end
  end

  def start
    url = "http://localhost:4567/api/v1/host/subscribe/#{@planning_session.host_name}"
    open_stream(url, display_message)
  end

  def start_poker
    Thread.new do
      start
    end
  end
end
