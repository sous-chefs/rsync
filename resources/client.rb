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
#--verbose               increase verbosity
#--quiet                 suppress non-error messages
#--no-motd               suppress daemon-mode MOTD (see caveat)
#--checksum              skip based on checksum, not mod-time & size
#--archive               archive mode; equals -rlptgoD (no -H,-A,-X)
#--no-OPTION             turn off an implied OPTION (e.g. --no-D)
#--recursive             recurse into directories
#--relative              use relative path names
#--no-implied-dirs       don't send implied dirs with --relative
#--backup                make backups (see --suffix & --backup-dir)
#--backup-dir=DIR        make backups into hierarchy based in DIR
#--suffix=SUFFIX         backup suffix (default ~ w/o --backup-dir)
#--update                skip files that are newer on the receiver
#--inplace               update destination files in-place
#--append                append data onto shorter files
#--append-verify         --append w/old data in file checksum
#--dirs                  transfer directories without recursing
#--links                 copy symlinks as symlinks
#--copy-links            transform symlink into referent file/dir
#--copy-unsafe-links     only "unsafe" symlinks are transformed
#--safe-links            ignore symlinks that point outside the tree
#--copy-dirlinks         transform symlink to dir into referent dir
#--keep-dirlinks         treat symlinked dir on receiver as dir
#--hard-links            preserve hard links
#--perms                 preserve permissions
#--executability         preserve executability
#--chmod=CHMOD           affect file and/or directory permissions
#--acls                  preserve ACLs (implies -p)
#--xattrs                preserve extended attributes
#--owner                 preserve owner (super-user only)
#--group                 preserve group
#--devices               preserve device files (super-user only)
#--specials              preserve special files
#--times                 preserve modification times
#--omit-dir-times        omit directories from --times
#--super                 receiver attempts super-user activities
#--fake-super            store/recover privileged attrs using xattrs
#--sparse                handle sparse files efficiently
#--dry-run               perform a trial run with no changes made
#--whole-file            copy files whole (w/o delta-xfer algorithm)
#--one-file-system       don't cross filesystem boundaries
#--block-size=SIZE       force a fixed checksum block-size
#--rsh=COMMAND           specify the remote shell to use
#--rsync-path=PROGRAM    specify the rsync to run on remote machine
#--existing              skip creating new files on receiver
#--ignore-existing       skip updating files that exist on receiver
#--remove-source-files   sender removes synchronized files (non-dir)
#--del                   an alias for --delete-during
#--delete                delete extraneous files from dest dirs
#--delete-before         receiver deletes before transfer (default)
#--delete-during         receiver deletes during xfer, not before
#--delete-delay          find deletions during, delete after
#--delete-after          receiver deletes after transfer, not before
#--delete-excluded       also delete excluded files from dest dirs
#--ignore-errors         delete even if there are I/O errors
#--force                 force deletion of dirs even if not empty
#--max-delete=NUM        don't delete more than NUM files
#--max-size=SIZE         don't transfer any file larger than SIZE
#--min-size=SIZE         don't transfer any file smaller than SIZE
#--partial               keep partially transferred files
#--partial-dir=DIR       put a partially transferred file into DIR
#--delay-updates         put all updated files into place at end
#--prune-empty-dirs      prune empty directory chains from file-list
#--numeric-ids           don't map uid/gid values by user/group name
#--timeout=SECONDS       set I/O timeout in seconds
#--contimeout=SECONDS    set daemon connection timeout in seconds
#--ignore-times          don't skip files that match size and time
#--size-only             skip files that match in size
#--modify-window=NUM     compare mod-times with reduced accuracy
#--temp-dir=DIR          create temporary files in directory DIR
#--fuzzy                 find similar file for basis if no dest file
#--compare-dest=DIR      also compare received files relative to DIR
#--copy-dest=DIR         ... and include copies of unchanged files
#--link-dest=DIR         hardlink to files in DIR when unchanged
#--compress              compress file data during the transfer
#--compress-level=NUM    explicitly set compression level
#--skip-compress=LIST    skip compressing files with suffix in LIST
#--cvs-exclude           auto-ignore files in the same way CVS does
#--filter=RULE           add a file-filtering RULE
#                        repeated: --filter='- .rsync-filter'
#--exclude=PATTERN       exclude files matching PATTERN
#--exclude-from=FILE     read exclude patterns from FILE
#--include=PATTERN       don't exclude files matching PATTERN
#--include-from=FILE     read include patterns from FILE
#--files-from=FILE       read list of source-file names from FILE
#--from0                 all *from/filter files are delimited by 0s
#--protect-args          no space-splitting; wildcard chars only
#--address=ADDRESS       bind address for outgoing socket to daemon
#--port=PORT             specify double-colon alternate port number
#--sockopts=OPTIONS      specify custom TCP options
#--blocking-io           use blocking I/O for the remote shell
#--stats                 give some file-transfer stats
#--8-bit-output          leave high-bit chars unescaped in output
#--human-readable        output numbers in a human-readable format
#--progress              show progress during transfer
#--itemize-changes       output a change-summary for all updates
#--out-format=FORMAT     output updates using the specified FORMAT
#--log-file=FILE         log what we're doing to the specified FILE
#--log-file-format=FMT   log updates using the specified FMT
#--password-file=FILE    read daemon-access password from FILE
#--list-only             list the files instead of copying them
#--bwlimit=KBPS          limit I/O bandwidth; KBytes per second
#--write-batch=FILE      write a batched update to FILE
#--only-write-batch=FILE like --write-batch but w/o updating dest
#--read-batch=FILE       read a batched update from FILE
#--protocol=NUM          force an older protocol version to be used
#--iconv=CONVERT_SPEC    request charset conversion of filenames
#--checksum-seed=NUM     set block/file checksum seed (advanced)
#--ipv4                  prefer IPv4
#--ipv6                  prefer IPv6
#--version               print version number
#--help                  show this help (see below for -h comment)

actions :execute, :stop
default_action :execute

attribute :name, :kind_of => String, :name_attribute => true
attribute :as_user, :kind_of => String, :required => true
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
attribute :timeout, :kind_of => Integer, :default => 1200
attribute :contimeout, :kind_of => Integer, :default => 1200
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
