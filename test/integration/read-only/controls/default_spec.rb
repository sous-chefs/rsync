control 'read-only' do
  # rsync is serving /tmp
  describe command('rsync rsync://127.0.0.1') do
    its('stdout') { should match /tmp/ }
    its('exit_status') { should eq 0 }
  end

  describe ini '/etc/rsyncd.conf' do
    its('tmp.read only') { should cmp 'true' }  # rsync is readonly
    its('tmp.uid') { should cmp 'nobody' }      # rsync is using nobody:nobody
    its('tmp.gid') { should cmp 'nobody' }      # rsync is using nobody:nobodyend
  end
end
