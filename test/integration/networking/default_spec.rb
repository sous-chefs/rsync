describe package('rsync') do
  it { should be_installed }
end

describe command('ps aux | grep rsync') do
  its('exit_status') { should eq 0 }
end

# rsync is serving /data/repos/prod/centos
describe command('rsync rsync://127.0.0.1') do
  its('stdout') { should match /centos-prod/ }
  its('exit_status') { should eq 0 }
end

describe file('/etc/rsyncd.conf') do
  its('content') { should match /path = \/data\/repos\/prod\/centos/ } # rsync added path
  its('content')  { should match /comment = CentOS prod mirror/ } # rsync added comment
  its('content')  { should match /read only = true/ } # rsync is readonly
  its('content')  { should match /list = true/ } # rsync has list true
  its('content')  { should match /uid = nobody/ } # rsync is using nobody:nobody
  its('content')  { should match /gid = nobody/ } # rsync is using nobody:nobody
  its('content')  { should match /hosts allow = 127.0.0.1, 10.4.1.0\/24, 192.168.4.0\/24/ } # rsync networking is setup
  its('content')  { should match /hosts deny = 0.0.0.0\/0/ } # rsync networking is setup
  its('content')  { should match /max connections = 10/ } # rsync networking is setup
  its('content')  { should match /transfer logging = true/ } # rsync networking is setup
  its('content')  { should match /log file = \/tmp\/centos-sync/ } # rsync networking is setup
  its('content')  { should match /pre-xfer exec = \/bin\/true/ } # rsync networking is setup
  its('content')  { should match /post-xfer exec = \/bin\/true/ } # rsync networking is setup
  its('content')  { should match /incoming chmod = a=r,u\+w,D\+x/ } # rsync networking is setup
  its('content')  { should match /outgoing chmod = a=r,u\+w,D\+x/ } # rsync networking is setup
end
