#
# Cookbook:: rsync
# Recipe:: server
#
# Copyright:: 2012-2016, Chef Software, Inc.
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

case node['platform_family']
when 'rhel', 'amazon'
  # RedHat does not provide an init script for rsyncd
  template '/etc/init.d/rsyncd' do
    source 'rsync-init.erb'
    owner  'root'
    group  'root'
    mode   '0755'
  end
when 'debian'
  template '/etc/default/rsync' do
    source 'rsync-defaults.erb'
    owner  'root'
    group  'root'
    mode   '0644'
  end
end

service node['rsyncd']['service'] do
  action  [:enable, :start]
  only_if { ::File.exist?(node['rsyncd']['config']) }
end
