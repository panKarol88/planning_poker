class PlanningSessionService
  include RequestHelper
  include LoggerHelper
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

  private

  def create_planning_session(voters_count, host_name)
    @planning_session = PlanningSession.new(voters_count, host_name)
  end

  def display_message
    Proc.new do |chunk|
      if chunk.present?
        message = JSON.parse chunk
        case
        when message['vote'].present?
          handle_vote message['vote']
        when message['text'].present?
          handle_text message['text']
        else
          puts message
        end
      end
    end
  end

  def handle_vote(vote_message)
    @@planning_results << vote_message
    @@vote_count += 1
    DisplayService.new().show_progress(@@vote_count, @planning_session.voters_count)

    if @@vote_count >= @planning_session.voters_count
      @result = count_result(@@planning_results)
      DisplayService.new().show_results(@@planning_results, @result)
    end
  end

  def handle_text(text)
    DisplayService.new().show_text(text)
  end

  def count_result(data)
    points_array = data.map{|d| d['points']}
    sorted_points = points_array.group_by{|i| i}.map do |point,votes|
      [votes.count, point]
    end.sort.reverse

    if sorted_points.count == 1 || sorted_points[0][0] > sorted_points[1][0]
      return sorted_points[0][1]
    elsif sorted_points[0][0] == sorted_points[1][0]
      return 'DRAW'
    end
  end

  def close
    url = "http://localhost:4567/api/v1/host/unsubscribe/#{@planning_session.host_name}"
    send_get(url)
  end

  def start
    url = "http://localhost:4567/api/v1/host/subscribe/#{@planning_session.host_name}"
    open_stream(url, display_message)
  end

  def start_poker
    close
    DisplayService.new().show_progress(@@vote_count, @planning_session.voters_count)
    Thread.new do
      start
    end
  end
end
