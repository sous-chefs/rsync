apt_update 'update' if platform_family?('debian')

include_recipe 'rsync::server'

rsync_serve 'centos-prod' do
  path             '/data/repos/prod/centos'
  comment          'CentOS prod mirror'
  read_only        true
  use_chroot       true
  list             true
  uid              'nobody'
  gid              'nobody'
  hosts_allow      '127.0.0.1, 10.4.1.0/24, 192.168.4.0/24'
  hosts_deny       '0.0.0.0/0'
  max_connections  10
  transfer_logging true
  log_file         '/tmp/centos-sync'
  prexfer_exec     '/bin/true'
  postxfer_exec    '/bin/true'
  incoming_chmod   'a=r,u+w,D+x'
  outgoing_chmod   'a=r,u+w,D+x'
end
