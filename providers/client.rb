#
# Author:: Stathy Touloumis (<stathy@opscode.com>)
# Cookbook Name:: rsync
# Provider:: client
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
#

require 'chef/mixin/shell_out'
require 'chef/mixin/language'

include Chef::Mixin::ShellOut

action :execute do
  unless @current_resource.running
    shell_out!(start_command)
    new_resource.updated_by_last_action(true)
    Chef::Log.info( %Q(Starting command for resource #{new_resource.client_name}) )
  end
  Chef::Log.info( %Q(Nothing to do, resource running "#{new_resource.client_name}") )
end

action :stop do
  if @current_resource.running
    shell_out!(stop_command)
    if @current_resource.running
      Chef::Log.warn( %Q(Unable to gracefully stop, using kill on "#{new_resource.client_name}") )
      shell_out!(kill_command)
    end
    Chef::Log.info( %Q(Stopped command for resource "#{new_resource.client_name}") )
    new_resource.updated_by_last_action(true)
  end
end

protected

def status_command
  cmd = start_command
  <<-EOF
  ps -A | grep '#{cmd}' | grep -v grep
  EOF
end

def start_command
  %Q(#{cmd})
end

def stop_command
  cmd = start_command
  <<-EOF
  killall -QUIT $(ps -A | grep '#{cmd}' | grep -v grep | awk '{print $1}')
  EOF
end

def kill_command
  cmd = start_command
  <<-EOF
  killall -KILL $(ps -A | grep '#{cmd}' | grep -v grep | awk '{print $1}')
  EOF
end

def determine_current_status!
  client_running?
end

def client_running?
  begin
    if shell_out(status_command).exitstatus == 0
      @current_resource.running true
      Chef::Log.debug( %Q("#{new_resource.client_name}" is running) )
    end
  rescue Mixlib::ShellOut::ShellCommandFailed, SystemCallError
    @current_resource.running false
      Chef::Log.debug( %Q("#{new_resource.client_name}" is NOT running) )
    nil
  end
end
