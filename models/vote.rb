class Vote
  include ActiveModel::Validations

  AVAILABLE_VALUES = [1, 2, 3, 5, 8].freeze

  validates :voter_name, :host_name, presence: true
  validates :voter_name, :host_name, format: { with: /\A[a-zA-Z0-9]+\Z/ }
  validates :points, numericality: { only_integer: true }
  validates :points, inclusion: {
      in: AVAILABLE_VALUES,
      message: " - These are only available values: #{AVAILABLE_VALUES}" }
  validate :host_cannot_vote

  attr_reader :voter_name, :host_name, :points

  def initialize(voter_name, host_name, points)
    @voter_name = voter_name
    @host_name = host_name
    @points = points.to_i
  end

  def body
    { vote: { voter_name: voter_name, points: points }, host_name: host_name }
  end

  private

  def host_cannot_vote
    if voter_name == host_name
      errors.add(:voter_name, ' --- You cannot bet at your own casino!')
    end
  end
end
