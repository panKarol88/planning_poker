class Vote
  include ActiveModel::Validations

  AVAILABLE_VALUES = [1, 2, 3, 5, 8].freeze

  validates :voter_name, :host_name, presence: true
  validates :points, inclusion: {
      in: AVAILABLE_VALUES,
      message: " - These are only available values: #{AVAILABLE_VALUES}" }

  attr_reader :voter_name, :host_name, :points

  def initialize(voter_name, host_name, points)
    @voter_name = voter_name
    @host_name = host_name
    @points = points.to_i if is_i?(points)
  end

  def body
    {voter_name: voter_name, host_name: host_name, points: points}
  end

  private

  def is_i?(points)
    /\A[-+]?\d+\z/ === points
  end
end
