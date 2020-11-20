control 'simple' do
  # rsync is serving /foo and /tmp alphabetically
  describe command 'rsync rsync://127.0.0.1' do
    its('stdout') { should match /foo\s*\ntmp/ }
    its('exit_status') { should eq 0 }
  end
end
