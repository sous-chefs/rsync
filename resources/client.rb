#
# Author:: Stathy Touloumis (<stathy@opscode.com>)
# Cookbook Name:: rsync
# Resource:: client
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

actions :execute, :stop
default_action :execute

attribute :source, :kind_of => String, :required => true
attribute :destination, :kind_of => String, :required => true
# Map to arguments
attribute :exclude, :kind_of => Array, :default => []
attribute :include, :kind_of => Array, :default => []
attribute :verbose, :default => false
attribute :quiet, :default => false
attribute :checksum, :default => false
attribute :archive, :default => false
attribute :recursive, :default => false
attribute :relative, :default => false
attribute :update, :default => false
attribute :inplace, :default => false
attribute :append, :default => false
attribute :append_verify, :default => false
attribute :dirs, :default => false
attribute :links, :default => false
attribute :copy_links, :default => false
attribute :copy_unsafe_links, :default => false
attribute :safe_links, :default => false
attribute :copy_dirlinks, :default => false
attribute :keep_dirlinks, :default => false
attribute :hard_links, :default => false
attribute :perms, :default => false
attribute :executability, :default => false
attribute :chmod, :kind_of => String
attribute :acls, :default => false
attribute :xattrs, :default => false
attribute :owner, :default => false
attribute :group, :default => false
attribute :devices, :default => false
attribute :specials, :default => false
attribute :times, :default => false
attribute :omit_dir_times, :default => false
attribute :super, :default => false
attribute :fake_super, :default => false
attribute :sparse, :default => false
attribute :dry_run, :default => false
attribute :whole_file, :default => false
attribute :one_file_system, :default => false
attribute :block_size, :default => false
attribute :existing, :default => false
attribute :ignore_existing, :default => false
attribute :remove_source_files, :default => false
attribute :delete_during, :default => false
attribute :delete_delay, :default => false
attribute :delete_after, :default => false
attribute :delete_excluded, :default => false
attribute :ignore_errors, :default => false
attribute :force, :default => false
attribute :max_delete, :kind_of => Integer
attribute :max_size, :kind_of => Integer
attribute :min_size, :kind_of => Integer
attribute :partial, :default => false
attribute :partial_dir, :kind_of => String
attribute :delay_updates, :default => false
attribute :prune_empty_dirs, :default => false
attribute :numeric_ids, :default => false
attribute :timeout, :kind_of => Integer
attribute :contimeout, :kind_of => Integer
attribute :ignore_times, :default => false
attribute :size_only, :default => false
attribute :modify_windows, :kind_of => Integer
attribute :temp_dir, :kind_of => String
attribute :fuzzy, :default => false
attribute :compare_dest, :kind_of => String
attribute :copy_dest, :kind_of => String
attribute :link_dest, :kind_of => String
attribute :compress, :default => false
attribute :compress_level, :kind_of => Integer
attribute :skip_compress, :kind_of => Array,:default => []
attribute :cvs_exclude, :default => false
attribute :filter, :kind_of => String
attribute :exclude_from, :kind_of => String
attribute :include_from, :kind_of => String
attribute :files_from, :kind_of => String
attribute :from0, :default => false
attribute :protect_args, :default => false
attribute :address, :kind_of => String
attribute :port, :kind_of => Integer
attribute :sockopts, :kind_of => String
attribute :blocking_io, :default => false
attribute :stats, :default => false
# Will need to work around this arg, possibly not common so skip
#attribute :8_bit_output, :default => false
attribute :human_readable, :default => false
# Extraneous information so skip
#attribute :progress, :default => false
attribute :itemize_changes, :default => false
attribute :output_format, :kind_of => String
attribute :log_file, :kind_of => String
attribute :log_file_format, :kind_of => String
attribute :password_file, :kind_of => String
attribute :list_only, :default => false
attribute :bwlimit, :kind_of => Integer
attribute :write_batch, :kind_of => String
attribute :only_write_batch, :kind_of => String
attribute :read_batch, :kind_of => String
attribute :protocol, :kind_of => Integer
attribute :iconv, :kind_of => String
attribute :checksum_seed, :kind_of => Integer
attribute :ip6, :default => false
attribute :ip4, :default => false
