default[:rsyncd][:log_file] = "/var/log/rsyncd.log"
default[:rsyncd][:pid_file] = "/var/run/rsyncd.pid"
default[:rsyncd][:lock_file] = "/var/run/subsys/rsyncd.lock"
default[:rsyncd][:port] = "873"
default[:rsyncd][:modules] = Hash.new
