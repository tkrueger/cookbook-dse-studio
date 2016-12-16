control 'check dse studio initialization' do

  describe service('dse_studio') do
    it { should be_enabled }
    it { should be_running }
  end

end
