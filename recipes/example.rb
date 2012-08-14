

include_recipe "rsync::server"

rsync_serve "tmp" do 
  path "/tmp"
  read_only true
  uid "nobody"
  gid "nobody"
end


rsync_serve "centos-prod" do 
  path "/data/repos/prod/centos"
  comment "CentOS prod mirror"
  read_only true
  uid "nobody"
  gid "nobody"
  list true
  hosts_allow "127.0.0.1, 10.4.1.0/24, 192.168.4.0/24"
  max_connections 10
  transfer_logging true
  log_file "/tmp/centos-sync"
end


