@test "rsync is running" {
  pgrep rsync
}

@test "rsync is serving centos-prod" {
  rsync rsync://127.0.0.1 | grep "centos-prod"
}

@test "rsync added path" {
  grep "path = /data/repos/prod/centos" /etc/rsyncd.conf
}

@test "rsync added comment" {
  grep "comment = CentOS prod mirror" /etc/rsyncd.conf
}

@test "rsync is readonly" {
  grep "read only = true" /etc/rsyncd.conf
}

@test "rsync has list true" {
  grep "list = true" /etc/rsyncd.conf
}

@test "rsync is using nobody:nobody" {
  grep "uid = nobody" /etc/rsyncd.conf
  grep "gid = nobody" /etc/rsyncd.conf
}

@test "rsync networking is setup" {
  grep "hosts allow = 127.0.0.1, 10.4.1.0/24, 192.168.4.0/24" /etc/rsyncd.conf
  grep "hosts deny = 0.0.0.0/0" /etc/rsyncd.conf
  grep "max connections = 10" /etc/rsyncd.conf
  grep "transfer logging = true" /etc/rsyncd.conf
  grep "log file = /tmp/centos-sync" /etc/rsyncd.conf
}
