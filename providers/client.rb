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
  if @current_resource.running
    Chef::Log.info( %Q(Nothing to do for resource "#{new_resource.name}", already running process "#{cmd}") )
    
  else
# Need to handle password, pipe to stdin when not using ssh keys
    cmd = start_command
    start_status = shell_out!(cmd).exit_status

    if start_status == 0
      new_resource.updated_by_last_action(true)
      Chef::Log.info( %Q(Starting command for resource #{new_resource.name}) )

    else
      Chef::Log.error( %Q(Unable to start process "#{cmd}" for resource #{new_resource.name}) )
      
    end

  end
end

action :stop do
  cmd = stop_command
  stop_status = shell_out!(cmd).exit_status

  if  stop_status == 0
    Chef::Log.info( %Q(Stopped process for resource "#{new_resource.name}") )
    new_resource.updated_by_last_action(true)

  else
    Chef::Log.warn( %Q(Unable to stop process for resource "#{new_resource.name}") )
    Chef::Log.info( %Q(Command "#{cmd}" status "#{stop_status} for resource "#{new_resource.name}") )

    if @current_resource.running
      cmd = kill_command
      Chef::Log.warn( %Q(Unable to gracefully stop, using "#{cmd} for resource "#{new_resource.name}") )

      kill_status = shell_out!(cmd).exit_status
      unless  kill_status == 0
        Chef::Log.error( %Q(Unable to stop process using "#{cmd}", status "#{kill_status} for resource "#{new_resource.name}") )
      end

    else
      Chef::Log.warn( %Q(Resource "#{new_resource.name}" unstoppable using "#{cmd}" with status "#{stop_status}") )

    end
  end
end

protected

def status_command
  cmd = start_command
  %Q(pgrep -x -f '#{cmd}')
end

def start_command
  args = ''
  new_resource.state_attr.each do |attr|
    continue if attr == 'source' or attr == 'destination'
#
# Need to construct command line arguments, ideally looping through attribute
# list - sorted if possible, filter out source and destination,
# identifying "type" - boolean and other, cat in order
#
#    if new_resource.send(name).type?
#      args += " --#{name}"
#    else
#      args += %Q( --#{name}=') + new_resource.send(name) + %q(')      
#    end
  end
  cmd = 'rsync ' + new_resource.source + " " + new_resource.destination + " " + args
  cmd
end

# -KILL $(ps -A | grep '#{cmd}' | grep -v grep | awk '{print $1}')
def stop_command
  cmd = start_command
  %Q(pkill -QUIT -x -f '#{cmd}')
end

def kill_command
  cmd = start_command
  %Q(pkill -KILL -x -f '#{cmd}')
end

def determine_current_status!
  client_running?
end

def client_running?
  begin
    if shell_out(status_command).exitstatus == 0
      @current_resource.running true
      Chef::Log.debug( %Q("#{new_resource.name}" is running) )
    end
  rescue Mixlib::ShellOut::ShellCommandFailed, SystemCallError
    @current_resource.running false
      Chef::Log.debug( %Q("#{new_resource.name}" is NOT running) )
    nil
  end
end
