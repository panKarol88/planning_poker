module PlanningHelper
  VOTING_STATUSES = {
      initialized: 'initialized',
      no_such_planning: 'no_such_planning',
      already_voted: 'already_voted',
      unsuccessful_vote: 'unsuccessful_vote',
      successful_vote: 'successful_vote',
      too_many_voters_already: 'too_many_voters_already',
      voters_max_reached: 'voters_max_reached'
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
      return '### ERROR ###'
    end
  end

  def print_progress(host_name)
    planning = r_get(host_name)
    show_progress(planning['voters'].count, planning['voters_max'])
  end

  def print_results(host_name)
    planning = r_get(host_name)
    show_results(planning['voters'])
  end
end
