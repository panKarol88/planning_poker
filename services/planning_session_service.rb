class PlanningSessionService
  attr_reader :planning_session

  def initialize(voters_count, host_name)
    create_planning_session voters_count, host_name
  end

  def proceed
    handle_validation
    start_poker
  end

  private

  def create_planning_session(voters_count, host_name)
    @planning_session = PlanningSession.new(voters_count, host_name)
  end

  def handle_validation
    puts @planning_session.errors.full_messages unless @planning_session.valid?
  end

  def start_poker
    Thread.new do
      VotingService.new(@planning_session).start
    end
  end
end
