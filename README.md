Description
===========
Rsync cookbook with rsyncd and rsync LWRP

More info on ryncd options can be found in the [Docs][1] 

Manages the use of rsyncd and rsync [Docs][1] for data distribution and syncing. This
not only installs the rsync package(s) but also includes LWRPs for initiating and managing the rsyncd server and
rsync client program.

Requirements
============

Platform
--------
Tested on CentOS 6, Ubuntu 12.04.

Resources/Providers
===================

serve
-----
This LWRP implements a rsync server module. The folowing params are chef-only, the rest implement the feature as described in the [rsyncd docs][1]
### Parameters
##### Required:
* `path` - Path which this module should server 

##### Optional:
Unless specified these paramaters use the rsyncd default values as refed in the [Rsyncd docs][1]. Params are *Strings* unless specified otherwise. 

* `name` - The name of this module that will be refrenced by rsync://foo/NAME. Defaults to the resource name.
* `config_path` - Path to write the rsyncd config Defaults to `node['rsyncd']['config']
* `comment` - Comment when rsync gets the list of modules from the server.
* `read_only` - *Boolean* - Serve this as a read-only module.
* `write_only`- *Boolean* - Serve this as a write-only module.
* `list` - *Boolean* - Add this module the the rsync modules list 
* `uid` - *String* - This parameter specifies the user name or user ID that file transfers to and from that module should take place as when the daemon was run as root.
* `gid` - *String* - This parameter specifies the group name or group ID that file transfers to and from that module should take place as when the daemon was run as root. 
* `auth_users` - This parameter specifies a comma and space-separated list of usernames that will be allowed to connect to this module. [more info][1]
* `secrets_file` - This parameter specifies the name of a file that contains the username:password pairs used for authenticating this module. [more info][1]
* `hosts_allow` - This parameter allows you to specify a list of patterns that are matched against a connecting clients hostname and IP address. If none of the patterns match then the connection is rejected. [more info][1]
* `hosts_deny` - This parameter allows you to specify a list of patterns that are matched against a connecting clients hostname and IP address. If the pattern matches then the connection is rejected. [more info][1]
* `max_connections` - *Fixnum* - *Default: `0` -  The maximum number of simultaneous connections you will allow. 
* `munge_symlinks` - *Boolean* - *Default: `true` - This parameter tells rsync to modify all incoming symlinks in a way that makes them unusable but recoverable. [more info][1]
* `use_chroot` - *Boolean* - the rsync daemon will chroot to the "path" before starting the file transfer with the client.
* `nemeric_ids` - *Boolean* - *Default: `true` - Enabling this parameter disables the mapping of users and groups by name for the current daemon module.
* `fake_super` - *Boolean* - This allows the full attributes of a file to be stored without having to have the daemon actually running as root.
* `exclude_from` - This parameter specifies the name of a file on the daemon that contains daemon exclude patterns. [more info][1]
* `exclude` - This parameter specifies the name of a file on the daemon that contains daemon exclude patterns. [more info][1]
* `include_from` - Analogue of `exclude_from`
* `include` - Analogue of `exclude`
* `strict_modes` - *Boolean* - If true, then the secrets file must not be readable by any user ID other than the one that the rsync daemon is running under.
* `log_file` - Path where you should store this modules log file. 
* `log_format` - The format is a text string containing embedded single-character escape sequences prefixed with a percent (%) character. An optional numeric field width may also be specified between the percent and the escape letter (e.g. "%-50n %8l %07p"). [more info][1]
* `transfer_logging` - This parameter enables per-file logging of downloads and uploads in a format somewhat similar to that used by ftp daemons. The daemon always logs the transfer at the end, so if a transfer is aborted, no mention will be made in the log file.
* `timeout` - *Fixnum* - Default: `600` - Using this parameter you can ensure that rsync won't wait on a dead client forever. The timeout is specified in seconds. A value of zero means no timeout.
* `dont_compress` - This parameter allows you to select filenames based on wildcard patterns that should not be compressed when pulling files from the daemon
* `lock_file` - This parameter specifies the file to use to support the "max connections" parameter. The rsync daemon uses record locking on this file to ensure that the max connections limit is not exceeded for the modules sharing the lock file. The default is /var/run/rsyncd.lock

client
-------

Please see the [rsync](http://linux.die.net/man/1/rsync) man page for detailed description of arguments. The
resource will not re-execute the command if it's already running.

# Actions
    - :execute:  Default action, will only run if matching process is not already running
    - :stop:     Stop a process matching cmd signature

# Attribute Parameters
    source:                *Required* "sync from" resource
    destination:           *Required* "sync to" resource
    
    exclude:               exclude files matching PATTERN
    include:               don't exclude files matching PATTERN
    verbose:               increase verbosity
    quiet:                 suppress non_error messages
    no_motd:               suppress daemon_mode MOTD (see caveat)
    checksum:              skip based on checksum, not mod_time & size
    archive:               archive mode; equals _rlptgoD (no _H,_A,_X)
    recursive:             recurse into directories
    relative:              use relative path names
    no_implied_dirs:       don't send implied dirs with relative
    backup:                make backups (see suffix & backup_dir)
    backup_dir:            make backups into hierarchy based in DIR
    suffix:                backup suffix (default ~ w/o backup_dir)
    update:                skip files that are newer on the receiver
    inplace:               update destination files in_place
    append:                append data onto shorter files
    append_verify:         append w/old data in file checksum
    dirs:                  transfer directories without recursing
    links:                 copy symlinks as symlinks
    copy_links:            transform symlink into referent file/dir
    copy_unsafe_links:     only "unsafe" symlinks are transformed
    safe_links:            ignore symlinks that point outside the tree
    copy_dirlinks:         transform symlink to dir into referent dir
    keep_dirlinks:         treat symlinked dir on receiver as dir
    hard_links:            preserve hard links
    perms:                 preserve permissions
    executability:         preserve executability
    chmod:                 affect file and/or directory permissions
    acls:                  preserve ACLs (implies _p)
    xattrs:                preserve extended attributes
    owner:                 preserve owner (super_user only)
    group:                 preserve group
    devices:               preserve device files (super_user only)
    specials:              preserve special files
    times:                 preserve modification times
    omit_dir_times:        omit directories from times
    super:                 receiver attempts super_user activities
    fake_super:            store/recover privileged attrs using xattrs
    sparse:                handle sparse files efficiently
    dry_run:               perform a trial run with no changes made
    whole_file:            copy files whole (w/o delta_xfer algorithm)
    one_file_system:       don't cross filesystem boundaries
    block_size:            force a fixed checksum block_size
    existing:              skip creating new files on receiver
    ignore_existing:       skip updating files that exist on receiver
    remove_source_files:   sender removes synchronized files (non_dir)
    delete:                delete extraneous files from dest dirs
    delete_before:         receiver deletes before transfer (default)
    delete_during:         receiver deletes during xfer, not before
    delete_delay:          find deletions during, delete after
    delete_after:          receiver deletes after transfer, not before
    delete_excluded:       also delete excluded files from dest dirs
    ignore_errors:         delete even if there are I/O errors
    force:                 force deletion of dirs even if not empty
    max_delete:            don't delete more than NUM files
    max_size:              don't transfer any file larger than SIZE
    min_size:              don't transfer any file smaller than SIZE
    partial:               keep partially transferred files
    partial_dir:           put a partially transferred file into DIR
    delay_updates:         put all updated files into place at end
    prune_empty_dirs:      prune empty directory chains from file_list
    numeric_ids:           don't map uid/gid values by user/group name
    timeout:               set I/O timeout in seconds
    contimeout:            set daemon connection timeout in seconds
    ignore_times:          don't skip files that match size and time
    size_only:             skip files that match in size
    modify_window:         compare mod_times with reduced accuracy
    temp_dir:              create temporary files in directory DIR
    fuzzy:                 find similar file for basis if no dest file
    compare_dest:          also compare received files relative to DIR
    copy_dest:             ... and include copies of unchanged files
    link_dest:             hardlink to files in DIR when unchanged
    compress:              compress file data during the transfer
    compress_level:        explicitly set compression level
    skip_compress:         skip compressing files with suffix in LIST
    cvs_exclude:           auto_ignore files in the same way CVS does
    filter:                add a file_filtering RULE
    exclude_from:          read exclude patterns from FILE
    include_from:          read include patterns from FILE
    files_from:            read list of source_file names from FILE
    from0:                 all from/filter files are delimited by 0s
    protect_args:          no space_splitting; wildcard chars only
    address:               bind address for outgoing socket to daemon
    port:                  specify double_colon alternate port number
    sockopts:              specify custom TCP options
    blocking_io:           use blocking I/O for the remote shell
    stats:                 give some file_transfer stats
    human_readable:        output numbers in a human_readable format
    progress:              show progress during transfer
    itemize_changes:       output a change_summary for all updates
    out_format:            output updates using the specified FORMAT
    log_file:              log what we're doing to the specified FILE
    log_file_format:       log updates using the specified FMT
    password_file:         read daemon_access password from FILE
    list_only:             list the files instead of copying them
    bwlimit:               limit I/O bandwidth; KBytes per second
    write_batch:           write a batched update to FILE
    only_write_batch:      like write_batch but w/o updating dest
    read_batch:            read a batched update from FILE
    protocol:              force an older protocol version to be used
    iconv:                 request charset conversion of filenames
    checksum_seed:         set block/file checksum seed (advanced)
    ipv4:                  prefer IPv4
    ipv6:                  prefer IPv6

Usage
=====

Examples
--------
More complex example in examples/recipes, but the simplest form of serving up a directory:

     rsync_serve "temp_module" do
       path "/tmp/foo"
     end


Examples
--------

    # /usr/bin/rsync --stats --links --recursive --times --compress --bwlimit=360 --exclude CVS --exclude .svn cpan.pair.com::CPAN /mirror/cpan
    rsync_client "perl cpan mirror" do
      source      "cpan.pair.com::CPAN"
      destination "/backup/mirror/cpan"
      recursive
      stats
      links
      times
      compress
      bwlimit     360
      exclude     %w( .svn CVS )
    end

    # /usr/bin/rsync --stats --links --recursive --times --compress --bwlimit=360 --exclude .svn --exclude CVS --delete-after rsync://mysql.mirrors.pair.com/mysql /mirror/mysql
    rsync_client "mysql mirror" do
      source      "rsync://mysql.mirrors.pair.com/mysql"
      destination "/mirrors/mysql"
      stats
      links
      recursive
      times
      compress
      bwlimit     360
      exclude     %w( .svn CVS )
      delete_after
    end

    # /usr/bin/rsync --stats --archive --exclude-svn --delete-after /home/customer/public_html /backup/website
    rsync_client "customer X site backup" do
      source      "/home/customer/public_html"
      destination "/backup/website"
      stats
      archive
      delete_after
      skip_compress %w( .tgz .tar.gz .zip )
    end

Recipes
=======

default
-------

Installs the rsync client

server
------
This recipe sets up the rsyncd service (on centos) and a stub service that is used by the `rsync_serve` LWRP. 

Attributes
==========
#### `node['rsyncd']['service']`  *(String)  default: "rsync"* 

The name of the init service 

#### `node['rsyncd']['config']`  *(Hash)  default: "/etc/rsyncd.conf"* 

Path to the rsyncd config file. This is the default, but the serve resource can write config files to arbitrary paths independant of this.

#### `node['rsyncd']['nice']`  *(String)  default: ""*  __Debian/ubuntu only__

#### `node['rsyncd']['ionice']`  *(String)  default: ""*  __Debian/ubuntu only__


#### `node['rsyncd']['globals']`  *(Hash)  default: {}* 

This is where you can store key-value pairs that coincide with rsyncd globals.
As of this writing these are the rsyncd globals per the [Rsyncd docs][1]

* __motd file:__ This parameter allows you to specify a "message of the day" to display to clients on each connect. This usually contains site information and any legal notices. The default is no motd file.
* __pid file:__ This parameter tells the rsync daemon to write its process ID to that file. If the file already exists, the rsync daemon will abort rather than overwrite the file.
* __port:__ You can override the default port the daemon will listen on by specifying this value (defaults to 873). This is ignored if the daemon is being run by inetd, and is superseded by the --port command-line option.
* __address:__ You can override the default IP address the daemon will listen on by specifying this value. This is ignored if the daemon is being run by inetd, and is superseded by the --address command-line option.
* __socket options:__ This parameter can provide endless fun for people who like to tune their systems to the utmost degree. You can set all sorts of socket options which may make transfers faster (or slower!). Read the man page for the setsockopt() system call for details on some of the options you may be able to set. By default no special socket options are set. These settings can also be specified via the --sockopts command-line option.

Refer to the documentation for rsyncd for more info.



    default[:rsync][:exclude] = %w( .svn CVS )
    default[:rsync][:bwlimit] = 10000
    default[:rsync][:name] = nil
    default[:rsync][:source] = nil
    default[:rsync][:destination] = nil
    
    # Role mysql_mirror - override
    override[:rsync][:name] = "mysql mirror"
    override[:rsync][:source] = "rsync://mysql.mirrors.pair.com/mysql"
    override[:rsync][:destination] = "/mirrors/mysql"
    
    # Role cpan_mirror - override
    override[:rsync][:name] = "cpan mirror"
    override[:rsync][:source] = "cpan.pair.com::CPAN"
    override[:rsync][:destination] = "/mirrors/CPAN"


License and Author
==================

Author:: cookbooks@opscode.com
Contributor:: Jesse Nelson <spheromak@gmail.com>
Contributor:: Stathy G. Touloumis <stathy@opscode.com>

Copyright:: 2013, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[1]: http://www.samba.org/ftp/rsync/rsyncd.conf.html "Rsyncd Docs"
