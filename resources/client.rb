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
attribute :password, :kind_of => String
# Map to arguments
attribute :source, :kind_of => String, :required => true
attribute :destination, :kind_of => String, :required => true
attribute :recursive, :default => true
attribute :exclude, :kind_of => String
attribute :include, :kind_of => String
attribute :verbose, :default => true
attribute :quiet, :default => true
attribute :checksum, :default => true
attribute :archive, :default => true
attribute :relative, :default => true
attribute :update, :default => true
attribute :inplace, :default => true
attribute :append, :default => true
attribute :append-verify, :default => true
attribute :dirs, :default => true
attribute :links, :default => true
attribute :copy-links, :default => true
attribute :copy-unsafe-links, :default => true
attribute :safe-links, :default => true
attribute :copy-dirlinks, :default => true
attribute :keep-dirlinks, :default => true
attribute :hard-links, :default => true
attribute :perms, :default => true
attribute :executability, :default => true
attribute :chmod, :kind_of => String
attribute :acls, :default => true
attribute :xattrs, :default => true
attribute :owner, :default => true
attribute :group, :default => true
attribute :devices, :default => true
attribute :specials, :default => true
attribute :times, :default => true
attribute :omit-dir-times, :default => true
attribute :super, :default => true
attribute :fake-super, :default => true
attribute :sparse, :default => true
attribute :dry-run, :default => true
attribute :whole-file, :default => true
attribute :one-file-system, :default => true
attribute :block-size, :default => true
attribute :existing, :default => true
attribute :ignore-existing, :default => true
attribute :remove-source-files, :default => true
attribute :delete-during, :default => true
attribute :delete-delay, :default => true
attribute :delete-after, :default => true
attribute :delete-excluded, :default => true
attribute :ignore-errors, :default => true
attribute :force, :default => true
attribute :max-delete, :kind_of => Integer
attribute :max-size, :kind_of => Integer
attribute :min-size, :kind_of => Integer
attribute :partial, :default => true
attribute :partial-dir, :kind_of => String
attribute :delay-updates, :default => true
attribute :prune-empty-dirs, :default => true
attribute :numeric-ids, :default => true
attribute :timeout, :kind_of => Integer, :default => 1200
attribute :contimeout, :kind_of => Integer, :default => 1200
attribute :ignore-times, :default => true
attribute :size-only, :default => true
attribute :modify-windows, :kind_of => Integer
attribute :temp-dir, :kind_of => String
attribute :fuzzy, :default => true
attribute :compare-dest, :kind_of => String
attribute :copy-dest, :kind_of => String
attribute :link-dest, :kind_of => String
attribute :compress, :default => true
attribute :compress-level, :kind_of => Integer
attribute :skip-compress, :kind_of => Array
attribute :cvs-exclude, :default => true
attribute :filter, :kind_of => String
attribute :exclude, :kind_of => String
attribute :exclude-from, :kind_of => String
attribute :include, :kind_of => String
attribute :include-from, :kind_of => String
attribute :exclude, :kind_of => String
attribute :files-from, :kind_of => String
attribute :exclude, :kind_of => String
attribute :from0, :default => true
attribute :protect-args, :default => true
attribute :address, :kind_of => String
attribute :port, :kind_of => Integer
attribute :sockopts, :kind_of => String
attribute :blocking-io, :default => true
attribute :stats, :default => true
# Will need to work around this arg, possibly not common so skip
#attribute :8-bit-output, :default => true
attribute :human-readable, :default => true
# Extraneous information so skip
#attribute :progress, :default => true
attribute :itemize-changes, :default => true
attribute :output-format, :kind_of => String
attribute :log-file, :kind_of => String
attribute :log-file-format, :kind_of => String
attribute :password-file, :kind_of => String
attribute :list-only, :default => true
attribute :bwlimit, :kind_of => Integer
attribute :write-batch, :kind_of => String
attribute :only-write-batch, :kind_of => String
attribute :read-batch, :kind_of => String
attribute :protocol, :kind_of => Integer
attribute :iconv, :kind_of => String
attribute :checksum-seed, :kind_of => Integer
attribute :ip6, :default => true
attribute :ip4, :default => true
