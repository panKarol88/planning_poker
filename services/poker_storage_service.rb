class PokerStorageService
  include StorageHelper
  include PlanningHelper
  attr_reader :host_name, :voter_name, :points, :voting_status

  def initialize(host_name:, voter_name:, points:)
    @host_name = host_name
    @voter_name = voter_name
    @points = points
    @voting_status = voting_statuses[:initialized]
  end

  def set_vote!
    # TODO redis lock
    planning = r_get(@host_name)
    if planning.blank?
      @voting_status = voting_statuses[:no_such_planning]
      return false
    end

    if planning['voters'][@voter_name].present?
      @voting_status = voting_statuses[:already_voted]
      return false
    end

    if planning['voters'].count >= planning['voters_max'].to_i
      @voting_status = voting_statuses[:too_many_voters_already]
      return false
    end

    planning['voters'][@voter_name] = @points
    r_response = r_set(@host_name, planning.to_json)

    if r_response != 'OK'
      @voting_status = voting_statuses[:unsuccessful_vote]
      return false
    end

    if planning['voters'].count == planning['voters_max'].to_i
      @voting_status = voting_statuses[:voters_max_reached]
      return true
    end

    @voting_status = voting_statuses[:successful_vote]
    return true
  end
end
