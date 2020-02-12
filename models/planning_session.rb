class PlanningSession
  include ActiveModel::Validations
  validates :voters_count, numericality: { greater_than: 0, only_integer: true }
  validates :host_name, presence: true
  validates :host_name, format: { with: /\A[a-zA-Z0-9]+\Z/ }

  attr_reader :voters_count, :host_name

  def initialize(voters_count, host_name)
    @voters_count = voters_count.to_i
    @host_name = host_name
  end

  def init_structure
    { voters_max: @voters_count, voters: {}}
  end
end
