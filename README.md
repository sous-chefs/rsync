# rsync Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/rsync.svg)](https://supermarket.chef.io/cookbooks/rsync)
[![CI State](https://github.com/sous-chefs/rsync/workflows/ci/badge.svg)](https://github.com/sous-chefs/rsync/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Rsync cookbook with custom resources for installing rsync and managing rsyncd modules. More info on rsyncd options can be found in the [Docs](https://download.samba.org/pub/rsync/rsyncd.conf.5).

## Migration

This release removes the legacy recipes and attributes. See [migration.md](migration.md) for the resource migration guide.

## Requirements

### Platforms

* AlmaLinux 8+
* Amazon Linux 2023+
* CentOS Stream 9+
* Debian 12+
* Fedora
* Oracle Linux 8+
* Red Hat Enterprise Linux 8+
* Rocky Linux 8+
* Ubuntu 22.04+

### Chef

- Chef >= 15.3

## Resources

* [rsync_install](documentation/rsync_install.md)
* [rsync_service](documentation/rsync_service.md)
* [rsync_serve](documentation/rsync_serve.md)

### serve

This resource implements an rsync server module. The following params are chef-only, the rest implement the feature as described in the [rsyncd docs][1].

#### Parameters

##### Required

* `path` - Path which this module should serve.

##### Optional

Unless specified these parameters use the rsyncd default values as referenced in the [Rsyncd docs][1]. Params are _Strings_ unless specified otherwise.

* `name` - The name of this module that will be referenced by rsync://foo/NAME. Defaults to the resource name.
* `config_path` - Path to write the rsyncd config. Defaults to `/etc/rsyncd.conf`.
* `globals` - Hash of global rsyncd directives for the config file.
* `service_name` - Service to notify when the config changes.
* `comment` - Comment when rsync gets the list of modules from the server.
* `read_only` - _Boolean_ - Serve this as a read-only module.
* `write_only` - _Boolean_ - Serve this as a write-only module.
* `list` - _Boolean_ - Add this module the the rsync modules list.
* `uid` - _String_ - User name or user ID that file transfers use when the daemon runs as root.
* `gid` - _String_ - Group name or group ID that file transfers use when the daemon runs as root.
* `auth_users` - Comma and space-separated list of usernames allowed to connect to this module. [more info][1]
* `secrets_file` - File containing username:password pairs for authenticating this module. [more info][1]
* `hosts_allow` - Hostname and IP patterns allowed to connect. [more info][1]
* `hosts_deny` - Hostname and IP patterns denied from connecting. [more info][1]
* `max_connections` - _Integer_ - *Default: `0` - The maximum number of simultaneous connections.
* `munge_symlinks` - _Boolean_ - *Default: `true` - Modify incoming symlinks in a safe, recoverable way. [more info][1]
* `use_chroot` - _Boolean_ - Chroot to the module path before starting file transfer.
* `numeric_ids` - _Boolean_ - *Default: `true` - Disable user/group name mapping for the module.
* `fake_super` - _Boolean_ - Store full file attributes without running the daemon as root.
* `exclude_from` - File containing daemon exclude patterns. [more info][1]
* `exclude` - Daemon exclude patterns. [more info][1]
* `include_from` - Analogue of `exclude_from`.
* `include` - Analogue of `exclude`.
* `strict_modes` - _Boolean_ - Require the secrets file to be readable only by the daemon user ID.
* `log_file` - Module log file path.
* `log_format` - Per-transfer log format. [more info][1]
* `transfer_logging` - Enables per-file logging of downloads and uploads.
* `timeout` - _Integer_ - Default: `600` - Client timeout in seconds.
* `dont_compress` - Filename patterns that should not be compressed.
* `lock_file` - Lock file used to support `max_connections`.
* `refuse_options` - Space-separated list of refused rsync command-line options.
* `prexfer_exec` - Command to run before each transfer to or from this module.
* `postxfer_exec` - Command to run after each transfer to or from this module.

## Usage

After loading the rsync cookbook you have access to the `rsync_serve` resource for serving up a generic rsyncd module with many options.

Declare `rsync_install` and `rsync_service` before `rsync_serve` when managing a daemon.

### Examples

Serve a directory:

```ruby
rsync_install 'default'
rsync_service 'default'

rsync_serve 'tmp' do
  path '/tmp'
end
```

Serve a directory with read only and specify uids:

```ruby
rsync_install 'default'
rsync_service 'default'

rsync_serve 'tmp' do
  path      '/tmp'
  uid       'nobody'
  gid       'nobody'
  read_only true
end
```

A more complex example with networking:

```ruby
rsync_install 'default'
rsync_service 'default'

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

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
