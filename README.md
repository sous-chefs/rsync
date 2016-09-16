# rsync Cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/rsync.svg?branch=master)](http://travis-ci.org/chef-cookbooks/rsync) [![Cookbook Version](https://img.shields.io/cookbook/v/rsync.svg)](https://supermarket.chef.io/cookbooks/rsync)

Rsync cookbook with rsyncd LWRP. More info on ryncd options can be found in the [Docs](http://www.samba.org/ftp/rsync/rsyncd.conf.html).

## Requirements

### Platforms

- Debian/Ubuntu
- RHEL/CentOS/Scientific/Amazon/Oracle

### Chef

- Chef 12.1+

### Cookbooks

- none

## Attributes

`node['rsyncd']['service']` _(String) default: "rsync"_

The name of the init service

`node['rsyncd']['config']` _(Hash) default: "/etc/rsyncd.conf"_

Path to the rsyncd config file. This is the default, but the serve resource can write config files to arbitrary paths independant of this.

`node['rsyncd']['nice']` _(String) default: ""_ **Debian/ubuntu only**

`node['rsyncd']['ionice']` _(String) default: ""_ **Debian/ubuntu only**

`node['rsyncd']['globals']` _(Hash) default: {}_

This is where you can store key-value pairs that coincide with rsyncd globals.

- **motd file:** This parameter allows you to specify a "message of the day" to display to clients on each connect. This usually contains site information and any legal notices. The default is no motd file.
- **pid file:** This parameter tells the rsync daemon to write its process ID to that file. If the file already exists, the rsync daemon will abort rather than overwrite the file.
- **port:** You can override the default port the daemon will listen on by specifying this value (defaults to 873). This is ignored if the daemon is being run by inetd, and is superseded by the --port command-line option.
- **address:** You can override the default IP address the daemon will listen on by specifying this value. This is ignored if the daemon is being run by inetd, and is superseded by the --address command-line option.
- **socket options:** This parameter can provide endless fun for people who like to tune their systems to the utmost degree. You can set all sorts of socket options which may make transfers faster (or slower!). Read the man page for the setsockopt() system call for details on some of the options you may be able to set. By default no special socket options are set. These settings can also be specified via the --sockopts command-line option.

Refer to the documentation for rsyncd for more info.

## Recipes

### default

This recipe simply installs the rsync package, nothing more.

## Resources/Providers

### serve

This LWRP implements a rsync server module. The folowing params are chef-only, the rest implement the feature as described in the [rsyncd docs][1]

#### Parameters

##### Required:

- `path` - Path which this module should server

##### Optional:

Unless specified these paramaters use the rsyncd default values as refed in the [Rsyncd docs][1]. Params are _Strings_ unless specified otherwise.

- `name` - The name of this module that will be refrenced by rsync://foo/NAME. Defaults to the resource name.
- `config_path` - Path to write the rsyncd config Defaults to `node['rsyncd']['config']
- `comment` - Comment when rsync gets the list of modules from the server.
- `read_only` - _Boolean_ - Serve this as a read-only module.
- `write_only`- _Boolean_ - Serve this as a write-only module.
- `list` - _Boolean_ - Add this module the the rsync modules list
- `uid` - _String_ - This parameter specifies the user name or user ID that file transfers to and from that module should take place as when the daemon was run as root.
- `gid` - _String_ - This parameter specifies the group name or group ID that file transfers to and from that module should take place as when the daemon was run as root.
- `auth_users` - This parameter specifies a comma and space-separated list of usernames that will be allowed to connect to this module. [more info][1]
- `secrets_file` - This parameter specifies the name of a file that contains the username:password pairs used for authenticating this module. [more info][1]
- `hosts_allow` - This parameter allows you to specify a list of patterns that are matched against a connecting clients hostname and IP address. If none of the patterns match then the connection is rejected. [more info][1]
- `hosts_deny` - This parameter allows you to specify a list of patterns that are matched against a connecting clients hostname and IP address. If the pattern matches then the connection is rejected. [more info][1]
- `max_connections` - _Fixnum_ - *Default: `0` - The maximum number of simultaneous connections you will allow.
- `munge_symlinks` - _Boolean_ - *Default: `true` - This parameter tells rsync to modify all incoming symlinks in a way that makes them unusable but recoverable. [more info][1]
- `use_chroot` - _Boolean_ - the rsync daemon will chroot to the "path" before starting the file transfer with the client.
- `nemeric_ids` - _Boolean_ - *Default: `true` - Enabling this parameter disables the mapping of users and groups by name for the current daemon module.
- `fake_super` - _Boolean_ - This allows the full attributes of a file to be stored without having to have the daemon actually running as root.
- `exclude_from` - This parameter specifies the name of a file on the daemon that contains daemon exclude patterns. [more info][1]
- `exclude` - This parameter specifies the name of a file on the daemon that contains daemon exclude patterns. [more info][1]
- `include_from` - Analogue of `exclude_from`
- `include` - Analogue of `exclude`
- `strict_modes` - _Boolean_ - If true, then the secrets file must not be readable by any user ID other than the one that the rsync daemon is running under.
- `log_file` - Path where you should store this modules log file.
- `log_format` - The format is a text string containing embedded single-character escape sequences prefixed with a percent (%) character. An optional numeric field width may also be specified between the percent and the escape letter (e.g. "%-50n %8l %07p"). [more info][1]
- `transfer_logging` - This parameter enables per-file logging of downloads and uploads in a format somewhat similar to that used by ftp daemons. The daemon always logs the transfer at the end, so if a transfer is aborted, no mention will be made in the log file.
- `timeout` - _Fixnum_ - Default: `600` - Using this parameter you can ensure that rsync won't wait on a dead client forever. The timeout is specified in seconds. A value of zero means no timeout.
- `dont_compress` - This parameter allows you to select filenames based on wildcard patterns that should not be compressed when pulling files from the daemon
- `lock_file` - This parameter specifies the file to use to support the "max connections" parameter. The rsync daemon uses record locking on this file to ensure that the max connections limit is not exceeded for the modules sharing the lock file. The default is /var/run/rsyncd.lock
- `refuse_options` - This parameter allows you to specify a space-separated list of rsync command line options that will be refused by your rsync daemon.
- `prexfer_exec` - A command to run before each transfer to or from this module. If this command fails, the transfer will be aborted.
- `postxfer_exec` - A command to run after each transfer to or from this module.

## Usage

After loading the rsync cookbook you have access to the `rsync_serve` resource for serving up a generic rsyncd module with many options.

**You must include the `rsync::server` recipe before you can use the LWRP** as shown in the examples below.

### Examples

Serve a directory:

```ruby
include_recipe 'rsync::server'

rsync_serve 'tmp' do
  path '/tmp'
end
```

Serve a directory with read only and specify uids:

```
include_recipe 'rsync::server'

rsync_serve 'tmp' do
  path      '/tmp'
  uid       'nobody'
  gid       'nobody'
  read_only true
end
```

A more complex example with networking:

```ruby
include_recipe 'rsync::server'

rsync_serve 'centos-prod' do
  path             '/data/repos/prod/centos'
  comment          'CentOS prod mirror'
  read_only        true
  use_chroot       true
  list             true
  uid              'nobody'
  gid              'nobody'
  hosts_allow      '127.0.0.1, 10.4.1.0/24, 192.168.4.0/24'
  hosts_deny       '0.0.0.0/0'
  max_connections  10
  transfer_logging true
  log_file         '/tmp/centos-sync'
  postxfer_exec    '/usr/local/bin/collect_things.sh'
end
```

## License & Authors

**Author:** Jesse Nelson ([spheromak@gmail.com](mailto:spheromak@gmail.com))

**Author:** Cookbook Engineering Team ([cookbooks@chef.io](mailto:cookbooks@chef.io))

**Copyright:** 2012-2016, Chef Software, Inc.

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
