package "rsync"

#typeofserver = search(:node, "name:#{node.name}").map { |n| n.run_list.select { |value| value == 'role[AppSrv]' || value == 'role[WebMainSrv]' }}.first.first

server = search(:node, "roles:#{node['rsync']['server']['role']}").map {|n| n["network"]["interfaces"][node['rsync']['preferred_network_interface']]["addresses"].select { |address, data| data["family"] == "inet" }}
server = server.first.keys.first unless server.empty? == true


template "/root/force_rsync_update.sh.erb" do
  source "force_rsync_update.sh.erb"
  owner "root"
  mode 0700
  variables(
      :server => server)
end

=begin
if node.roles[0] == "AppSrv" || node.roles[0] == "WebMainSrv"

  cron "SyncHTTPLogs" do
    action :create
    minute 0
    command "rsync -r -a -v /var/log/nginx rsync://#{node['addressess']['chef_server']}/#{node['hostname']}"
  end
end
=end
