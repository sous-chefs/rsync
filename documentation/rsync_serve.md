# rsync_serve

Adds or removes an rsync daemon module from an rsyncd configuration file.

## Actions

| Action    | Description                                          |
|-----------|------------------------------------------------------|
| `:create` | Adds the module to the rendered config. Default action. |
| `:add`    | Backwards-compatible alias for `:create`.          |
| `:delete` | Removes the module from the rendered config.        |
| `:remove` | Backwards-compatible alias for `:delete`.           |

## Properties

| Property           | Type    | Default              | Description                                      |
|--------------------|---------|----------------------|--------------------------------------------------|
| `config_path`      | String  | `'/etc/rsyncd.conf'` | Config file to render.                           |
| `globals`          | Hash    | `{}`                 | Global rsyncd directives for the config file.    |
| `service_name`     | String  | Platform default     | Service to notify when the config changes.       |
| `path`             | String  | Required             | Filesystem path served by this module.           |
| `comment`          | String  | `nil`                | Module comment shown in module listings.         |
| `read_only`        | Boolean | `nil`                | Sets `read only`.                                |
| `write_only`       | Boolean | `nil`                | Sets `write only`.                               |
| `list`             | Boolean | `nil`                | Sets whether the module appears in listings.     |
| `uid`              | String  | `nil`                | User used for file transfers.                    |
| `gid`              | String  | `nil`                | Group used for file transfers.                   |
| `auth_users`       | String  | `nil`                | Authorized users.                                |
| `secrets_file`     | String  | `nil`                | Secrets file path.                               |
| `hosts_allow`      | String  | `nil`                | Allowed hosts patterns.                          |
| `hosts_deny`       | String  | `nil`                | Denied hosts patterns.                           |
| `max_connections`  | Integer | `0`                  | Maximum simultaneous connections.                |
| `munge_symlinks`   | Boolean | `true`               | Sets `munge symlinks`.                           |
| `use_chroot`       | Boolean | `nil`                | Sets `use chroot`.                               |
| `numeric_ids`      | Boolean | `true`               | Sets `numeric ids`.                              |
| `fake_super`       | Boolean | `nil`                | Sets `fake super`.                               |
| `exclude_from`     | String  | `nil`                | Exclude file path.                               |
| `exclude`          | String  | `nil`                | Exclude patterns.                                |
| `include_from`     | String  | `nil`                | Include file path.                               |
| `include`          | String  | `nil`                | Include patterns.                                |
| `strict_modes`     | Boolean | `nil`                | Sets `strict modes`.                             |
| `log_file`         | String  | `nil`                | Module log file.                                 |
| `log_format`       | String  | `nil`                | Module log format.                               |
| `transfer_logging` | Boolean | `nil`                | Sets `transfer logging`.                         |
| `timeout`          | Integer | `600`                | Client timeout in seconds.                       |
| `dont_compress`    | String  | `nil`                | Patterns excluded from compression.              |
| `lock_file`        | String  | `nil`                | Lock file path.                                  |
| `refuse_options`   | String  | `nil`                | Refused rsync options.                           |
| `prexfer_exec`     | String  | `nil`                | Command run before transfer.                     |
| `postxfer_exec`    | String  | `nil`                | Command run after transfer.                      |
| `incoming_chmod`   | String  | `nil`                | Incoming chmod rules.                            |
| `outgoing_chmod`   | String  | `nil`                | Outgoing chmod rules.                            |

## Examples

### Serve a directory

```ruby
rsync_install 'default'
rsync_service 'default'

rsync_serve 'tmp' do
  path '/tmp'
end
```

### Serve a read-only directory

```ruby
rsync_serve 'tmp' do
  path '/tmp'
  uid 'nobody'
  gid 'nobody'
  read_only true
end
```

### Add global directives

```ruby
rsync_serve 'mirror' do
  globals(
    'motd_file' => '/etc/rsync.motd',
    'port' => 873
  )
  path '/srv/mirror'
  read_only true
end
```
