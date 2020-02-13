module PlanningHelper
  VOTING_STATUSES = {
      initialized: 'initialized',
      no_such_planning: 'no_such_planning',
      already_voted: 'already_voted',
      unsuccessful_vote: 'unsuccessful_vote',
      successful_vote: 'successful_vote',
      too_many_voters_already: 'too_many_voters_already',
      voters_max_reached: 'voters_max_reached',
      restarted: 'restarted',
      ended: 'ended'
  }.freeze

  def voting_statuses
    VOTING_STATUSES
  end

  def count_result(data)
    sorted_points = data.group_by{|i, v| v}.map do |point,votes|
      [votes.count, point]
    end.sort.reverse

    if sorted_points.count == 1 || sorted_points[0][0] > sorted_points[1][0]
      return sorted_points[0][1]
    elsif sorted_points[0][0] == sorted_points[1][0]
      return 'DRAW'
    else
      raise 'Result data corrupted.'
    end
  end

  def print_progress(host_name)
    planning = r_get(host_name)
    show_progress(planning['voters'].count, planning['voters_max'])
  end

  def print_results(host_name, display_to_host=false)
    planning = r_get(host_name)
    show_results(planning['voters'], display_to_host)
  end

  def note_all_voters(host_name, event, message='')
    send_post('client/push',
        { host_name: host_name, event: event, text: message})
  end
end
