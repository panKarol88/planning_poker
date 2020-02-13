RSpec.describe PlanningSession, type: :model do
  describe 'Object Methods' do
    it 'returns correct init value' do
      planning = PlanningSession.new(1, 'name')

      expect(planning.init_structure).to eq({ voters_max: 1, voters: {}})
    end
  end

  describe 'Validations' do
    it 'correct values' do
      planning = PlanningSession.new(1, 'host')
      expect(planning.valid?).to be_truthy
    end
    it 'for negative voters count' do
      planning = PlanningSession.new(-1, 'name')
      expect(planning.valid?).to be_falsey
    end
    it 'for zero voters count' do
      planning = PlanningSession.new(0, 'name')
      expect(planning.valid?).to be_falsey
    end
    it 'for float voters count' do
      planning = PlanningSession.new(0.5, 'name')
      expect(planning.valid?).to be_falsey
    end

    it 'no host name' do
      planning = PlanningSession.new(1, '')
      expect(planning.valid?).to be_falsey
    end
    it 'corrupt host name' do
      planning = PlanningSession.new(1, ' das sda')
      expect(planning.valid?).to be_falsey
    end
  end
end
