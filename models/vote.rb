class Vote
  include ActiveModel::Validations

  AVAILABLE_VALUES = [1, 2, 3, 5, 8].freeze

  validates :voter_name, :host_name, presence: true
  validates :points, numericality: { only_integer: true }
  validates :points, inclusion: {
      in: AVAILABLE_VALUES,
      message: " - These are only available values: #{AVAILABLE_VALUES}" }

  attr_reader :voter_name, :host_name, :points

  def initialize(voter_name, host_name, points)
    @voter_name = voter_name
    @host_name = host_name
    @points = points.to_i
  end

  def body
    { vote: { voter_name: voter_name, points: points }, host_name: host_name }
  end
end
