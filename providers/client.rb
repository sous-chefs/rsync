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
require 'open3'

include Chef::Mixin::ShellOut

action :execute do
  cmd = start_command

  if running?
    Chef::Log.info( %Q(Nothing to do for resource "#{@new_resource.name}", already running process "#{cmd}") )

  else
    error = false
    i, o, t = Open3.popen2e(cmd)
    status_t = Thread.new { error = true if t.value.exited? && t.value.exitstatus > 0 }
    status_t.join(1)

    if error
      output = o.readlines(5).join

      Chef::Log.error( %Q(Could not execute "#{cmd} for resource "#{@new_resource.name}"\n#{output}) )
      raise(output)

    else
      Process.detach(t.pid)
      @new_resource.updated_by_last_action(true)
      Chef::Log.info( %Q(Execution of resource "#{@new_resource.name}" complete) )
      
    end

  end
end

action :stop do
  cmd = stop_command
  stop_status = shell_out!(cmd).exitstatus

  if  stop_status == 0
    Chef::Log.info( %Q(Stopped process for resource "#{@new_resource.name}") )
    @new_resource.updated_by_last_action(true)

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

  cmd = 'rsync '
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
  args += " --xattrs" if @new_resource.xattrs == true
  args += " --owner" if @new_resource.owner == true
  args += " --group" if @new_resource.group == true
  args += " --devices" if @new_resource.devices == true
  args += " --specials" if @new_resource.specials == true
  args += " --times" if @new_resource.times == true
  args += " --omit-dir-times" if @new_resource.omit_dir_times == true
  args += " --super" if @new_resource.super == true
  args += " --fake-super" if @new_resource.fake_super == true
  args += " --sparse" if @new_resource.sparse == true
  args += " --dry-run" if @new_resource.dry_run == true
  args += " --whole-file" if @new_resource.whole_file == true
  args += " --one-file-system" if @new_resource.one_file_system == true
  args += " --block_size" if @new_resource.block_size == true
  args += " --existing" if @new_resource.existing == true
  args += " --ignore-existing" if @new_resource.ignore_existing == true
  args += " --remove-source-files" if @new_resource.remove_source_files == true
  args += " --delete-during" if @new_resource.delete_during == true
  args += " --delete-delay" if @new_resource.delete_delay == true
  args += " --delete-after" if @new_resource.delete_after == true
  args += " --delete-excluded" if @new_resource.delete_excluded == true
  args += " --ignore-errors" if @new_resource.ignore_errors == true
  args += " --force" if @new_resource.force == true
  args += " --partial" if @new_resource.partial == true
  args += " --max-delete=#{@new_resource.max_delete}" unless @new_resource.max_delete.nil?
  args += " --max-size=#{@new_resource.max_size}" unless @new_resource.max_size.nil?
  args += " --min-size=#{@new_resource.min_size}" unless @new_resource.min_size.nil?
  args += %Q( --partial-dir="#{@new_resource.partial_dir}") unless @new_resource.partial_dir.nil?
  args += " --delay-updates" if @new_resource.delay_updates == true
  args += " --prune-empty-dirs" if @new_resource.prune_empty_dirs == true
  args += " --numeric-ids" if @new_resource.numeric_ids == true
  args += " --timeout=#{@new_resource.timeout}" unless @new_resource.timeout.nil?
  args += " --contimeout=#{@new_resource.contimeout}" unless @new_resource.contimeout.nil?
  args += " --ignore-times" if @new_resource.ignore_times == true
  args += " --size-only" if @new_resource.size_only == true
  args += " --fuzzy" if @new_resource.fuzzy == true
  args += " --modify-windows=#{@new_resource.modify_windows}" unless @new_resource.modify_windows.nil?
  args += %Q( --temp-dir="#{@new_resource.temp_dir}") unless @new_resource.temp_dir.nil?
  args += %Q( --compare-dest="#{@new_resource.compare_dest}") unless @new_resource.compare_dest.nil?
  args += %Q( --copy-dest="#{@new_resource.copy_dest}") unless @new_resource.copy_dest.nil?
  args += %Q( --link-dest="#{@new_resource.link_dest}") unless @new_resource.link_dest.nil?
  args += " --compress" if @new_resource.compress == true
  args += " --compress-level=#{@new_resource.compress_level}" unless @new_resource.compress_level.nil?
  @new_resource.skip_compress.each { |i| args += %Q( --skip-compress="#{i}") } if @new_resource.skip_compress.count > 0
  args += " --cvs-exclude" if @new_resource.cvs_exclude == true
  args += %Q( --filter="#{@new_resource.filter}") unless @new_resource.filter.nil?
  args += %Q( --exclude-from="#{@new_resource.exclude_from}") unless @new_resource.exclude_from.nil?
  args += %Q( --include-from="#{@new_resource.include_from}") unless @new_resource.include_from.nil?
  args += %Q( --files-from="#{@new_resource.files_from}") unless @new_resource.files_from.nil?
  args += " --from0" if @new_resource.from0 == true
  args += " --protect-args" if @new_resource.protect_args == true
  args += %Q( --address="#{@new_resource.address}") unless @new_resource.address.nil?
  args += " --port=#{@new_resource.port}" unless @new_resource.port.nil?
  args += %Q( --sockopts="#{@new_resource.sockopts}") unless @new_resource.sockopts.nil?
  args += " --blocking-io" if @new_resource.blocking_io == true
  args += " --stats" if @new_resource.stats == true
  args += " --human-readable" if @new_resource.human_readable == true
  args += " --itemize-changes" if @new_resource.itemize_changes == true
  args += %Q( --output-format="#{@new_resource.output_format}") unless @new_resource.output_format.nil?
  args += %Q( --log-file="#{@new_resource.log_file}") unless @new_resource.log_file.nil?
  args += %Q( --log-file-format="#{@new_resource.log_file_format}") unless @new_resource.log_file_format.nil?
  args += %Q( --password-file="#{@new_resource.password_file}") unless @new_resource.password_file.nil?
  args += " --list-only" if @new_resource.list_only == true
  args += %Q( --write-batch="#{@new_resource.write_batch}") unless @new_resource.write_batch.nil?
  args += %Q( --only-write-batch="#{@new_resource.only_write_batch}") unless @new_resource.only_write_batch.nil?
  args += %Q( --read-batch="#{@new_resource.read_batch}") unless @new_resource.read_batch.nil?
  args += %Q( --iconv="#{@new_resource.iconv}") unless @new_resource.iconv.nil?
  args += " --protocol=#{@new_resource.protocol}" unless @new_resource.protocol.nil?
  args += " --checksum_seed=#{@new_resource.checksum_seed}" unless @new_resource.checksum_seed.nil?
  args += " --ip6" if @new_resource.ip6 == true
  args += " --ip4" if @new_resource.ip4 == true

  cmd += args + " " + @new_resource.source + " " + @new_resource.destination
end

def load_current_resource
  @current_resource = Chef::Resource::RsyncClient.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource
end

protected

# -KILL $(ps -A | grep '#{cmd}' | grep -v grep | awk '{print $1}')
def stop_command
  cmd = start_command
  %Q(pkill -QUIT -x -f 'rsync #{cmd}')
end

def kill_command
  cmd = start_command
  %Q(pkill -KILL -x -f 'rsync #{cmd}')
end

def running?
  begin
    if shell_out(status_command).exitstatus == 0
      Chef::Log.debug( %Q("#{@new_resource.name}" is running) )
    end
  rescue Mixlib::ShellOut::ShellCommandFailed, SystemCallError
      Chef::Log.debug( %Q("#{@new_resource.name}" is NOT running) )
    nil
  end
end
