#
# Cookbook:: rsync
# Recipe:: server
#
# Copyright:: 2012-2019, Chef Software, Inc.
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
#

include_recipe 'rsync::default'

systemd_unit 'rsync' do
  content <<~EOU
  [Unit]
  Description=fast remote file copy program daemon
  ConditionPathExists=#{node['rsyncd']['config']}

  [Service]
  EnvironmentFile=#{rsync_defaults_file}
  ExecStart=/usr/bin/rsync --daemon --no-detach --config #{node['rsyncd']['config']} "$OPTIONS"

  [Install]
  WantedBy=multi-user.target
  EOU
  unit_name "#{rsync_service_name}.service"
  notifies :restart, 'service[rsync]'
  action :create
end

template rsync_defaults_file do
  source 'rsync-defaults.erb'
  notifies :restart, 'service[rsync]'
end

service 'rsync' do
  service_name rsync_service_name
  action [:enable, :start]
end
