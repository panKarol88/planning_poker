class PlanningSession
  include ActiveModel::Validations
  validates :voters_count, numericality: { greater_than: 0, only_integer: true }
  validates :host_name, presence: true

  attr_reader :voters_count, :host_name

  def initialize(voters_count, host_name)
    @voters_count = voters_count
    @host_name = host_name
  end
end
