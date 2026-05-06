# rsync_service

Creates and manages the systemd rsync daemon service.

## Actions

* `:create` - Writes the systemd unit/defaults file and enables service.
* `:delete` - Stops/disables service and removes service artifacts.
* `:start` - Starts the service.
* `:stop` - Stops the service.
* `:restart` - Restarts the service.

## Properties

* `config_path` - String, default `'/etc/rsyncd.conf'`. Path passed to `rsync --daemon --config`.
* `defaults_file` - String, platform default. Service environment file path.
* `options` - String, default `''`. Additional daemon command-line options.
* `service_name` - String, platform default. Service name, `rsync` on Debian and `rsyncd` elsewhere.

## Examples

### Create and start the daemon

```ruby
rsync_install 'default'

rsync_service 'default'
```

### Use a custom config path and daemon options

```ruby
rsync_service 'custom' do
  config_path '/etc/rsyncd-custom.conf'
  options '--port=8873'
end
```

### Delete service artifacts

```ruby
rsync_service 'default' do
  action :delete
end
```
