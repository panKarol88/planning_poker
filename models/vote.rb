class Vote
  include ActiveModel::Validations

  AVAILABLE_VALUES = [1, 2, 3, 5, 8].freeze

  validates :voter_name, :host_name, presence: true
  validates :size, inclusion: { in: AVAILABLE_VALUES }

  attr_reader :voter_name, :host_name, :points

  def initialize(voter_name, host_name, points)
    @voter_name = voter_name
    @host_name = host_name
    @points = points
  end

  def body
    {voter_name: voter_name, host_name: host_name, points: points}
  end
end
