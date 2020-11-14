control 'default' do
  service_name = os.family == 'debian' ? 'rsync' : 'rsyncd'
  describe package 'rsync' do
    it { should be_installed }
  end

  describe service service_name do
    it { should be_enabled }
    it { should be_running }
  end

  describe port 873 do
    it { should be_listening }
  end
end
