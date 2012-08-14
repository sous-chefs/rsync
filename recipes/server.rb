
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
  action [ :nothing ]
end


