@test "rsync is running" {
  pgrep rsync
}

@test "rsync is serving /tmp" {
  rsync rsync://127.0.0.1 | grep "tmp"
}

@test "rsync is readonly" {
  grep "read only = true" /etc/rsyncd.conf
}

@test "rsync is using nobody:nobody" {
  grep "uid = nobody" /etc/rsyncd.conf
  grep "gid = nobody" /etc/rsyncd.conf
}
