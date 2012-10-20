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
  cmd = start_command

  if running?
    Chef::Log.info( %Q(Nothing to do for resource "#{@new_resource.name}", already running process "#{cmd}") )

  else
    status = shell_out!(cmd, :user => @new_resource.as_user).exitstatus

    if status == 0
      @new_resource.updated_by_last_action(true)
      Chef::Log.info( %Q(Execution of resource #{@new_resource.name} complete) )

    else
      Chef::Log.error( %Q(Status: "#{status}" Unable to start process "#{cmd}" for resource #{@new_resource.name}) )
      raise
      
    end

  end
end

action :stop do
  cmd = stop_command
  stop_status = shell_out!(cmd).exitstatus

  if  stop_status == 0
    Chef::Log.info( %Q(Stopped process for resource "#{@new_resource.name}") )
    new_resource.updated_by_last_action(true)

  else
    Chef::Log.warn( %Q(Unable to stop process for resource "#{@new_resource.name}") )
    Chef::Log.info( %Q(Command "#{cmd}" status "#{stop_status} for resource "#{@new_resource.name}") )

    if running?
      cmd = kill_command
      Chef::Log.warn( %Q(Unable to gracefully stop, using "#{cmd} for resource "#{@new_resource.name}") )

      kill_status = shell_out!(cmd).exitstatus
      unless  kill_status == 0
        Chef::Log.error( %Q(Unable to stop process using "#{cmd}", status "#{kill_status} for resource "#{@new_resource.name}") )
      end

    else
      Chef::Log.warn( %Q(Resource "#{@new_resource.name}" unstoppable using "#{cmd}" with status "#{stop_status}") )

    end
  end
end

protected

def status_command
  cmd = start_command
  %Q(pgrep -x -f '#{cmd}')
end

def start_command

  cmd = 'rsync ' + @new_resource.source + " " + @new_resource.destination
  args = ''

  args += " --archive" if @new_resource.archive == true
  @new_resource.exclude.each { |ex| args += %Q( --exclude="#{ex}") } if @new_resource.exclude.count > 0
  @new_resource.include.each { |ex| args += %Q( --include="#{ex}") } if @new_resource.include.count > 0
  args += " --bwlimit=#{@new_resource.bwlimit}" unless @new_resource.bwlimit.nil?
  args += " --recursive" if @new_resource.recursive == true
  args += " --verbose" if @new_resource.verbose == true
  args += " --quiet" if @new_resource.quiet == true
  args += " --recursive" if @new_resource.recursive == true
  args += " --checksum" if @new_resource.checksum == true
  args += " --relative" if @new_resource.relative == true
  args += " --update" if @new_resource.update == true
  args += " --inplace" if @new_resource.inplace == true
  args += " --recursive" if @new_resource.recursive == true
  args += " --append" if @new_resource.append == true
  args += " --append-verify" if @new_resource.append_verify == true
  args += " --dirs" if @new_resource.dirs == true
  args += " --links" if @new_resource.links == true
  args += " --copy-links" if @new_resource.copy_links == true
  args += " --copy-unsafe-links" if @new_resource.copy_unsafe_links == true
  args += " --safe-links" if @new_resource.safe_links == true
  args += " --copy-dirlinks" if @new_resource.copy_dirlinks == true
  args += " --keep-dirlinks" if @new_resource.keep_dirlinks == true
  args += " --hard-links" if @new_resource.hard_links == true
  args += " --perms" if @new_resource.perms == true
  args += " --executability" if @new_resource.executability == true
  args += " --chmod" if @new_resource.chmod == true
  args += " --acls" if @new_resource.acls == true

#attribute :xattrs, :default => false
#attribute :owner, :default => false
#attribute :group, :default => false
#attribute :devices, :default => false
#attribute :specials, :default => false
#attribute :times, :default => false
#attribute :omit_dir_times, :default => false
#attribute :super, :default => false
#attribute :fake_super, :default => false
#attribute :sparse, :default => false
#attribute :dry_run, :default => false
#attribute :whole_file, :default => false
#attribute :one_file_system, :default => false
#attribute :block_size, :default => false
#attribute :existing, :default => false
#attribute :ignore_existing, :default => false
#attribute :remove_source_files, :default => false
#attribute :delete_during, :default => false
#attribute :delete_delay, :default => false
#attribute :delete_after, :default => false
#attribute :delete_excluded, :default => false
#attribute :ignore_errors, :default => false
#attribute :force, :default => false
#attribute :max_delete, :kind_of => Integer
#attribute :max_size, :kind_of => Integer
#attribute :min_size, :kind_of => Integer
#attribute :partial, :default => false
#attribute :partial_dir, :kind_of => String
#attribute :delay_updates, :default => false
#attribute :prune_empty_dirs, :default => false
#attribute :numeric_ids, :default => false
#attribute :timeout, :kind_of => Integer, :default => 1200
#attribute :contimeout, :kind_of => Integer, :default => 1200
#attribute :ignore_times, :default => false
#attribute :size_only, :default => false
#attribute :modify_windows, :kind_of => Integer
#attribute :temp_dir, :kind_of => String
#attribute :fuzzy, :default => false
#attribute :compare_dest, :kind_of => String
#attribute :copy_dest, :kind_of => String
#attribute :link_dest, :kind_of => String
#attribute :compress, :default => false
#attribute :compress_level, :kind_of => Integer
#attribute :skip_compress, :kind_of => Array
#attribute :cvs_exclude, :default => false
#attribute :filter, :kind_of => String
#attribute :exclude_from, :kind_of => String
#attribute :include_from, :kind_of => String
#attribute :files_from, :kind_of => String
#attribute :from0, :default => false
#attribute :protect_args, :default => false
#attribute :address, :kind_of => String
#attribute :port, :kind_of => Integer
#attribute :sockopts, :kind_of => String
#attribute :blocking_io, :default => false
#attribute :stats, :default => false
## Will need to work around this arg, possibly not common so skip
##attribute :8_bit_output, :default => false
#attribute :human_readable, :default => false
## Extraneous information so skip
##attribute :progress, :default => false
#attribute :itemize_changes, :default => false
#attribute :output_format, :kind_of => String
#attribute :log_file, :kind_of => String
#attribute :log_file_format, :kind_of => String
#attribute :password_file, :kind_of => String
#attribute :list_only, :default => false
#attribute :bwlimit, :kind_of => Integer
#attribute :write_batch, :kind_of => String
#attribute :only_write_batch, :kind_of => String
#attribute :read_batch, :kind_of => String
#attribute :protocol, :kind_of => Integer
#attribute :iconv, :kind_of => String
#attribute :checksum_seed, :kind_of => Integer
#attribute :ip6, :default => false
#attribute :ip4, :default => false

  cmd += args
end

def load_current_resource
  @current_resource = Chef::Resource::RsyncClient.new(new_resource.name)
  @current_resource.name(new_resource.name)
  @current_resource
end

protected

# -KILL $(ps -A | grep '#{cmd}' | grep -v grep | awk '{print $1}')
def stop_command
  cmd = start_command
  %Q(pkill -QUIT -x -f '#{cmd}')
end

def kill_command
  cmd = start_command
  %Q(pkill -KILL -x -f '#{cmd}')
end

def running?
  begin
    if shell_out(status_command).exitstatus == 0
      Chef::Log.debug( %Q("#{new_resource.name}" is running) )
    end
  rescue Mixlib::ShellOut::ShellCommandFailed, SystemCallError
      Chef::Log.debug( %Q("#{new_resource.name}" is NOT running) )
    nil
  end
end
