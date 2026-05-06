# Migration Guide

## Breaking Change

This cookbook no longer ships recipes or attributes. Use custom resources directly in wrapper
cookbooks or policy recipes.

## Recipe Replacements

### `rsync::default`

Replace:

```ruby
include_recipe 'rsync::default'
```

With:

```ruby
rsync_install 'default'
```

### `rsync::server`

Replace:

```ruby
include_recipe 'rsync::server'
```

With:

```ruby
rsync_install 'default'
rsync_service 'default'
```

## Attribute Replacements

* `node['rsyncd']['config']` maps to `config_path` on `rsync_service` and `rsync_serve`.
* `node['rsyncd']['globals']` maps to `globals` on `rsync_serve`.
* `node['rsyncd']['options']` maps to `options` on `rsync_service`.

## Examples

### Before

```ruby
include_recipe 'rsync::server'

rsync_serve 'tmp' do
  path '/tmp'
  read_only true
end
```

### After

```ruby
rsync_install 'default'
rsync_service 'default'

rsync_serve 'tmp' do
  path '/tmp'
  read_only true
end
```

### Custom daemon options and globals

```ruby
rsync_install 'default'

rsync_service 'default' do
  options '--port=8873'
end

rsync_serve 'mirror' do
  globals('motd_file' => '/etc/rsync.motd')
  path '/srv/mirror'
  read_only true
end
```

See the test cookbook under `test/cookbooks/test/recipes/` for working migration examples.
