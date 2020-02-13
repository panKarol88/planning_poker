RSpec.describe Vote, type: :model do
  describe 'Object Methods' do
    it 'returns correct body value' do
      vote = Vote.new('votername', 'hostname', 1)
      expect(vote.body).to eq({ vote: { voter_name: 'votername', points: 1 }, host_name: 'hostname' })
    end
  end

  describe 'Validations' do
    it 'correct values' do
      vote = Vote.new('votername', 'hostname', 1)
      expect(vote.valid?).to be_truthy
    end
    it 'presence voter name' do
      vote = Vote.new('', 'hostname', 1)
      expect(vote.valid?).to be_falsey
    end
    it 'presence host name name' do
      vote = Vote.new('votername', '', 1)
      expect(vote.valid?).to be_falsey
    end
    it 'format host name name' do
      vote = Vote.new('votername', 'fa ada', 1)
      expect(vote.valid?).to be_falsey
    end
    it 'format voter name name' do
      vote = Vote.new('voter name', 'hostname', 1)
      expect(vote.valid?).to be_falsey
    end
    it 'include available points' do
      vote = Vote.new('voter name', 'hostname', 12)
      expect(vote.valid?).to be_falsey
    end
    it 'host cannot vote' do
      vote = Vote.new('hostname', 'hostname', 12)
      expect(vote.valid?).to be_falsey
    end
  end
end
