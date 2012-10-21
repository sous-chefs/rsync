Description
===========
Manages the use of [rsync](http://http://en.wikipedia.org/wiki/Rsync) for data distribution and syncing. This
not only installs the rsync package but also includes LWRPs for initiating and managing the rsync client
program.

[![Build Status](https://secure.travis-ci.org/stathy/rsync.png)](http://travis-ci.org/stathy/rsync/tree/COOK-1773)

Requirements
============
Platform
--------
Tested with CentOS 6 and Ubuntu 10.10. Uses the `rsync` packages.

Attributes
==========
default[:rsync][:exclude] = %w( .svn CVS )
default[:rsync][:bwlimit] = 10000

Resources/Providers
===================

client
-------

Please see the [rsync](http://linux.die.net/man/1/rsync) man page for detailed description of arguments.

# Actions
- :execute: Default action, will only run if matching process is not already running
- :stop: Stop a process matching cmd signature

# Attribute Parameters
source: *Required* "sync from" resource
destination: *Required* "sync to" resource
exclude: Explicitly filter out files and dirs which match. Takes array of string values
include: Explicitly include files and dirs which match. Takes array of string values
verbose:
quiet:
checksum:
archive:
recursive:
relative:
update:
inplace:
append:
append_verify:
dirs:
links:
copy_links:
copy_unsafe_links:
safe_links:
copy_dirlinks:
keep_dirlinks:
hard_links:
perms:
executability:
chmod:
acls:
xattrs:
owner:
group:
devices:
specials:
times:
omit_dir_times:
super:
fake_super:
sparse:
dry_run:
whole_file:
one_file_system:
block_size:
existing:
ignore_existing:
remove_source_files:
delete_during:
delete_delay:
delete_after:
delete_excluded:
ignore_errors:
force:
max_delete:
max_size:
min_size:
partial:
partial_dir:
delay_updates:
prune_empty_dirs:
numeric_ids:
timeout:
contimeout:
ignore_times:
size_only:
modify_windows:
temp_dir:
fuzzy:
compare_dest:
copy_dest:
link_dest:
compress:
compress_level:
skip_compress:
cvs_exclude:
filter:
exclude_from:
include_from:
files_from:
from0:
protect_args:
address:
port:
sockopts:
blocking_io:
stats:
human_readable:
itemize_changes:
output_format:
log_file:
log_file_format:
password_file:
list_only:
bwlimit:
write_batch:
only_write_batch:
read_batch:
protocol:
iconv:
checksum_seed:
ip6:
ip4:

Usage
=====

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

mysql_mirror
-------
Creates a mysql mirror

cpan_mirror
-------
Creates a perl cpan mirror

Attributes
==========
default[:rsync][:exclude] = %w( .svn CVS )
default[:rsync][:bwlimit] = 10000

# Role mysql_mirror
default[:rsync][:name] = "mysql mirror"
default[:rsync][:destination] = "rsync://mysql.mirrors.pair.com/mysql"
default[:rsync][:source] = "/mirrors/mysql"

# Role cpan_mirror
default[:rsync][:name] = "cpan mirror"
default[:rsync][:destination] = "cpan.pair.com::CPAN"
default[:rsync][:source] = "/mirrors/CPAN"


License and Author
==================

Author:: Stathy G. Touloumis

Copyright:: 2012, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
