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
  cmd = start_command()

  if running?
    Chef::Log.info( %Q(Nothing to do for resource "#{@new_resource.name}", already running process "#{cmd}") )

  else
    error = false
    i, o, t = Open3.popen2e(cmd)
    status_t = Thread.new { error = true if t.value.exited? && t.value.exitstatus() > 0 }
    status_t.join(1)

    if error
      output = o.readlines(5).join()

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
  cmd = stop_command()
  stop_status = shell_out!(cmd).exitstatus()

  if  stop_status == 0
    Chef::Log.info( %Q(Stopped process for resource "#{@new_resource.name}") )
    @new_resource.updated_by_last_action(true)

  else
    Chef::Log.warn( %Q(Unable to stop process for resource "#{@new_resource.name}") )
    Chef::Log.info( %Q(Command "#{cmd}" status "#{stop_status} for resource "#{@new_resource.name}") )

    if running?
      cmd = kill_command()
      Chef::Log.warn( %Q(Unable to gracefully stop, using "#{cmd} for resource "#{@new_resource.name}") )

      kill_status = shell_out!(cmd).exitstatus()
      unless  kill_status == 0
        Chef::Log.error( %Q(Unable to stop process using "#{cmd}", status "#{kill_status} for resource "#{@new_resource.name}") )
      end

    else
      Chef::Log.warn( %Q(Resource "#{@new_resource.name}" unstoppable using "#{cmd}" with status "#{stop_status}") )

    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::RsyncClient.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource
end

protected

def start_command
  if @cmd.nil?
    cmd = 'rsync'

    cmd += " --archive" if @new_resource.archive == true
    @new_resource.exclude.each { |ex| cmd += %Q( --exclude="#{ex}") } if @new_resource.exclude.count > 0
    @new_resource.include.each { |ex| cmd += %Q( --include="#{ex}") } if @new_resource.include.count > 0
    cmd += " --bwlimit=#{@new_resource.bwlimit}" unless @new_resource.bwlimit.nil?
    cmd += " --recursive" if @new_resource.recursive == true
    cmd += " --verbose" if @new_resource.verbose == true
    cmd += " --quiet" if @new_resource.quiet == true
    cmd += " --recursive" if @new_resource.recursive == true
    cmd += " --checksum" if @new_resource.checksum == true
    cmd += " --relative" if @new_resource.relative == true
    cmd += " --update" if @new_resource.update == true
    cmd += " --inplace" if @new_resource.inplace == true
    cmd += " --recursive" if @new_resource.recursive == true
    cmd += " --append" if @new_resource.append == true
    cmd += " --append-verify" if @new_resource.append_verify == true
    cmd += " --dirs" if @new_resource.dirs == true
    cmd += " --links" if @new_resource.links == true
    cmd += " --copy-links" if @new_resource.copy_links == true
    cmd += " --copy-unsafe-links" if @new_resource.copy_unsafe_links == true
    cmd += " --safe-links" if @new_resource.safe_links == true
    cmd += " --copy-dirlinks" if @new_resource.copy_dirlinks == true
    cmd += " --keep-dirlinks" if @new_resource.keep_dirlinks == true
    cmd += " --hard-links" if @new_resource.hard_links == true
    cmd += " --perms" if @new_resource.perms == true
    cmd += " --executability" if @new_resource.executability == true
    cmd += " --chmod" if @new_resource.chmod == true
    cmd += " --acls" if @new_resource.acls == true
    cmd += " --xattrs" if @new_resource.xattrs == true
    cmd += " --owner" if @new_resource.owner == true
    cmd += " --group" if @new_resource.group == true
    cmd += " --devices" if @new_resource.devices == true
    cmd += " --specials" if @new_resource.specials == true
    cmd += " --times" if @new_resource.times == true
    cmd += " --omit-dir-times" if @new_resource.omit_dir_times == true
    cmd += " --super" if @new_resource.super == true
    cmd += " --fake-super" if @new_resource.fake_super == true
    cmd += " --sparse" if @new_resource.sparse == true
    cmd += " --dry-run" if @new_resource.dry_run == true
    cmd += " --whole-file" if @new_resource.whole_file == true
    cmd += " --one-file-system" if @new_resource.one_file_system == true
    cmd += " --block_size" if @new_resource.block_size == true
    cmd += " --existing" if @new_resource.existing == true
    cmd += " --ignore-existing" if @new_resource.ignore_existing == true
    cmd += " --remove-source-files" if @new_resource.remove_source_files == true
    cmd += " --delete-during" if @new_resource.delete_during == true
    cmd += " --delete-delay" if @new_resource.delete_delay == true
    cmd += " --delete-after" if @new_resource.delete_after == true
    cmd += " --delete-excluded" if @new_resource.delete_excluded == true
    cmd += " --ignore-errors" if @new_resource.ignore_errors == true
    cmd += " --force" if @new_resource.force == true
    cmd += " --partial" if @new_resource.partial == true
    cmd += " --max-delete=#{@new_resource.max_delete}" unless @new_resource.max_delete.nil?
    cmd += " --max-size=#{@new_resource.max_size}" unless @new_resource.max_size.nil?
    cmd += " --min-size=#{@new_resource.min_size}" unless @new_resource.min_size.nil?
    cmd += %Q( --partial-dir="#{@new_resource.partial_dir}") unless @new_resource.partial_dir.nil?
    cmd += " --delay-updates" if @new_resource.delay_updates == true
    cmd += " --prune-empty-dirs" if @new_resource.prune_empty_dirs == true
    cmd += " --numeric-ids" if @new_resource.numeric_ids == true
    cmd += " --timeout=#{@new_resource.timeout}" unless @new_resource.timeout.nil?
    cmd += " --contimeout=#{@new_resource.contimeout}" unless @new_resource.contimeout.nil?
    cmd += " --ignore-times" if @new_resource.ignore_times == true
    cmd += " --size-only" if @new_resource.size_only == true
    cmd += " --fuzzy" if @new_resource.fuzzy == true
    cmd += " --modify-windows=#{@new_resource.modify_windows}" unless @new_resource.modify_windows.nil?
    cmd += %Q( --temp-dir="#{@new_resource.temp_dir}") unless @new_resource.temp_dir.nil?
    cmd += %Q( --compare-dest="#{@new_resource.compare_dest}") unless @new_resource.compare_dest.nil?
    cmd += %Q( --copy-dest="#{@new_resource.copy_dest}") unless @new_resource.copy_dest.nil?
    cmd += %Q( --link-dest="#{@new_resource.link_dest}") unless @new_resource.link_dest.nil?
    cmd += " --compress" if @new_resource.compress == true
    cmd += " --compress-level=#{@new_resource.compress_level}" unless @new_resource.compress_level.nil?
    @new_resource.skip_compress.each { |i| cmd += %Q( --skip-compress="#{i}") } if @new_resource.skip_compress.count > 0
    cmd += " --cvs-exclude" if @new_resource.cvs_exclude == true
    cmd += %Q( --filter="#{@new_resource.filter}") unless @new_resource.filter.nil?
    cmd += %Q( --exclude-from="#{@new_resource.exclude_from}") unless @new_resource.exclude_from.nil?
    cmd += %Q( --include-from="#{@new_resource.include_from}") unless @new_resource.include_from.nil?
    cmd += %Q( --files-from="#{@new_resource.files_from}") unless @new_resource.files_from.nil?
    cmd += " --from0" if @new_resource.from0 == true
    cmd += " --protect-args" if @new_resource.protect_args == true
    cmd += %Q( --address="#{@new_resource.address}") unless @new_resource.address.nil?
    cmd += " --port=#{@new_resource.port}" unless @new_resource.port.nil?
    cmd += %Q( --sockopts="#{@new_resource.sockopts}") unless @new_resource.sockopts.nil?
    cmd += " --blocking-io" if @new_resource.blocking_io == true
    cmd += " --stats" if @new_resource.stats == true
    cmd += " --human-readable" if @new_resource.human_readable == true
    cmd += " --itemize-changes" if @new_resource.itemize_changes == true
    cmd += %Q( --output-format="#{@new_resource.output_format}") unless @new_resource.output_format.nil?
    cmd += %Q( --log-file="#{@new_resource.log_file}") unless @new_resource.log_file.nil?
    cmd += %Q( --log-file-format="#{@new_resource.log_file_format}") unless @new_resource.log_file_format.nil?
    cmd += %Q( --password-file="#{@new_resource.password_file}") unless @new_resource.password_file.nil?
    cmd += " --list-only" if @new_resource.list_only == true
    cmd += %Q( --write-batch="#{@new_resource.write_batch}") unless @new_resource.write_batch.nil?
    cmd += %Q( --only-write-batch="#{@new_resource.only_write_batch}") unless @new_resource.only_write_batch.nil?
    cmd += %Q( --read-batch="#{@new_resource.read_batch}") unless @new_resource.read_batch.nil?
    cmd += %Q( --iconv="#{@new_resource.iconv}") unless @new_resource.iconv.nil?
    cmd += " --protocol=#{@new_resource.protocol}" unless @new_resource.protocol.nil?
    cmd += " --checksum_seed=#{@new_resource.checksum_seed}" unless @new_resource.checksum_seed.nil?
    cmd += " --ip6" if @new_resource.ip6 == true
    cmd += " --ip4" if @new_resource.ip4 == true
  
    @cmd = "#{cmd} #{@new_resource.source} #{@new_resource.destination}"
  end
  
  @cmd
end

def status_command
  cmd = start_command()
  %Q(pgrep -x -f '#{cmd}')
end

# -KILL $(ps -A | grep '#{cmd}' | grep -v grep | awk '{print $1}')
def stop_command
  cmd = start_command()
  %Q(pkill -QUIT -x -f '#{cmd}')
end

def kill_command
  cmd = start_command()
  %Q(pkill -KILL -x -f '#{cmd}')
end

def running?
  cmd = status_command()
  t = Open3.popen2e(cmd).last()
  running = ( t.value.exitstatus() == 0 ? true : false )
  Chef::Log.debug( %Q("#{cmd}" "#{t.value.exitstatus}" "#{running}") )
  
  running
end
