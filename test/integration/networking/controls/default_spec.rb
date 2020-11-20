control 'networking' do
  # rsync is serving /data/repos/prod/centos
  describe command 'rsync rsync://127.0.0.1' do
    its('stdout') { should match /centos-prod\s+CentOS prod mirror/ }
    its('exit_status') { should eq 0 }
  end

  describe ini '/etc/rsyncd.conf' do
    its('centos-prod.path') { should cmp '/data/repos/prod/centos' }  # rsync added path
    its('centos-prod.comment') { should cmp 'CentOS prod mirror' }    # rsync added comment
    its('centos-prod.read only') { should cmp 'true' }                # rsync is readonly
    its('centos-prod.list') { should cmp 'true' }   # rsync has list true
    its('centos-prod.uid') { should cmp 'nobody' }  # rsync is using nobody:nobody
    its('centos-prod.gid') { should cmp 'nobody' }  # rsync is using nobody:nobody
    its('centos-prod.hosts allow') { should cmp '127.0.0.1, 10.4.1.0/24, 192.168.4.0/24' }
    its('centos-prod.hosts deny') { should cmp '0.0.0.0/0' }
    its('centos-prod.max connections') { should cmp '10' }
    its('centos-prod.transfer logging') { should cmp 'true' }
    its('centos-prod.log file') { should cmp '/tmp/centos-sync' }
    its('centos-prod.pre-xfer exec') { should cmp '/bin/true' }
    its('centos-prod.post-xfer exec') { should cmp '/bin/true' }
    its('centos-prod.incoming chmod') { should cmp 'a=r,u+w,D+x' }
    its('centos-prod.outgoing chmod') { should cmp 'a=r,u+w,D+x' }
  end
end
