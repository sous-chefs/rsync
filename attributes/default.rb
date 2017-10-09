#
# Cookbook:: rsync
# Attribute:: default
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
srv_provider = ::Chef::Platform::ServiceHelpers.service_resource_providers
default['rsyncd']['init'] = if srv_provider.include?(:systemd)
                              'systemd'
                            else
                              'sysvinit'
                            end
default['rsyncd']['service'] = case node['platform_family']
                               when 'rhel'
                                 # Currently only RHEL platform allow the use
                                 # of the systemd socket for rsyncd
                                 case node['rsyncd']['init']
                                 when 'systemd'
                                   'rsyncd.socket'
                                 when 'sysvinit'
                                   'rsyncd'
                                 end
                               when 'debian'
                                 'rsync'
                               else
                                 'rsyncd'
                               end

default['rsyncd']['config']  = '/etc/rsyncd.conf'
default['rsyncd']['globals'] = {}

# only used on debian platforms
default['rsyncd']['nice'] = ''
default['rsyncd']['ionice'] = ''
