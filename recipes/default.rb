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

package "rsync"

template "#{node[:rsync][:rsyncd_conf]}" do
  source "rsync_default.erb"
  owner "root"
  group "root"
  mode 644
  variables(
    :daemon => node[:rsync][:daemon],
    :rsyncd_conf => node[:rsync][:rsyncd_conf],
    :rsyncd_opts => node[:rsync][:rsyncd_opts],
    :rsync_nice => node[:rsync][:rsync_nice]
  )
end

if node[:rsync][:daemon] == "true"
  service "rsync" do
    action [:enable, :start]
  end
end
