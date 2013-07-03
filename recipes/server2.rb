#
# Cookbook Name:: rsync
# Recipe:: default
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# -2013 paigeadele (paigeadele@gmail.com)

package "rsync"
package "xinetd"

group "rsync" do
  action :nothing
  members "rsync"
  append true

end

user "rsync" do
  action :create
  comment "rsync"
  system true
  shell "/bin/false"
  notifies :create, "group[rsync]", :immediately
end


directory "#{node['rsync']['server']['src_root']}" do
  owner "rsync"
  group "rsync"
  mode "0755"
  action :create
  recursive true
end

directory "/var/rsync" do
  owner "rsync"
  group "rsync"
  mode "0755"
  action :create
  recursive true
end

node['rsync']['server']['vhosts'].each do |vhost|
  if vhost['vhost'] == nil || vhost['vhost'] == ""
    next
  end
  if vhost['server'] != nil and vhost['server'] != ""
    git "#{node['rsync']['server']['src_root']}/#{vhost['vhost']}" do
      repository vhost['server']
      if vhost['branch'] != nil && vhost['branch'] != ""
        reference vhost['branch']
      end
      action :sync
    end
  else
    directory "#{node['rsync']['server']['src_root']}/#{vhost['vhost']}" do
      action :create
      owner "rsync"
      group "rsync"
      recursive true
      mode 0755
    end
  end
end

=begin
#web server logs
begin
  webservers = search(:node, "roles:AppSrv OR roles:WebMainSrv")
  webservers.each do |webserver|
    directory "#{node['rsync']['server']['src_root']}/nginx-logs/#{webserver['hostname']}" do
      action :create
      owner "rsync"
      group "rsync"
      recursive true
      mode 0755
    end
  end
rescue => e
  log "unknown error #{e}" do
    level :warn
  end
end
=end

template "/etc/xinetd.d/rsync" do
  source "xinetd.rsync.erb"
  owner "root"
  mode 0644
end


template "/etc/default/rsync" do
  source "etc.default.erb"
  owner "root"
  mode 0644
end

begin
  template "/etc/rsyncd.conf" do
    source "server.erb"
    owner "root"
    mode 0644
#    variables(:webservers => webservers)
  end
rescue => e
  log "error creating rsyncd.conf!! #{e}" do
    level :fatal
  end
end

execute "restartxinetd" do
  command "/etc/init.d/xinetd restart"
  action :run
end

