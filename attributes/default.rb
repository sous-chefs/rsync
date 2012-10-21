#
# Author:: Stathy Touloumis (<stathy@opscode.com>)
# Cookbook Name:: rsync
# Attributes:: default
#
# Copyright:: 2012, Opscode, Inc <legal@opscode.com>
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

default[:rsync][:exclude] = %w( .svn CVS )
default[:rsync][:bwlimit] = 10000

# mysql mirror role
#default[:rsync][:name] = "mysql mirror"
#default[:rsync][:destination] = "rsync://mysql.mirrors.pair.com/mysql"
#default[:rsync][:source] = "/mirrors/mysql"

#cpan mirror role
#default[:rsync][:name] = "cpan mirror"
#default[:rsync][:destination] = "cpan.pair.com::CPAN"
#default[:rsync][:source] = "/mirrors/CPAN"
#default[:rsync][:exclude] = %w( .svn CVS )
#default[:rsync][:bwlimit] = 10000
