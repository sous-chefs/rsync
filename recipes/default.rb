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

# Static
rsync "mysql mirror" do
  destination "rsync://mysql.mirrors.pair.com/mysql"
  source      "/mirrors/mysql""
  password    "P455w0rd"
  exclude     %w( .svn CVS )
  bwlimit     100
  recursive
  stats
  links
  compress
end

# Dynamic, attribute driven
rsync "#{node[:rsync][:mysql_mirror][:name]}" do
  destination node[:rsync][:mysql_mirror][:destination]
  source      node[:rsync][:mysql_mirror][:source]
  password    node[:rsync][:mysql_mirror][:password]
  exclude     node[:rsync][:mysql_mirror][:excludes]
  bwlimit     node[:rsync][:mysql_mirror][:bwlimit]
  recursive
  stats
  links
  compress
end
