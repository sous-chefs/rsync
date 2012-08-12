
#
# make sure the package is isntalled
#
include_recipe "rsync"

template "/etc/init.d/rsyncd" do 
  source "rsync-rhel-init.erb"
  owner "root"
  group "root"
  mode 0755
end

service "rsyncd" do
  action [ :enable ]
end

template "/etc/rsyncd.conf" do 
  owner "root"
  group "root"
  mode  0640
  variables(
    :port      => node[:rsyncd][:port],
    :log_file  => node[:rsyncd][:log_file],
    :pid_file  => node[:rsyncd][:pid_file],
    :lock_file => node[:rsyncd][:lock_file]
  )
  notifies :restart, "service[rsyncd]" 
end


