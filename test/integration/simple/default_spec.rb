describe package('rsync') do
  it { should be_installed }
end

describe command('ps aux | grep rsync') do
  its('exit_status') { should eq 0 }
end

# rsync is serving /foo and /tmp alphabetically
describe command('rsync rsync://127.0.0.1') do
  its('stdout') { should match /foo\s*\ntmp/ }
  its('exit_status') { should eq 0 }
end
