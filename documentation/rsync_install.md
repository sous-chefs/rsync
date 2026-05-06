# rsync_install

Installs or removes the rsync package.

## Actions

* `:install` - Installs the rsync package. Default action.
* `:create` - Alias for `:install`.
* `:remove` - Removes the rsync package.
* `:delete` - Alias for `:remove`.

## Properties

* `package_name` - String or Array, default `'rsync'`. Package name or names to use.

## Examples

### Install rsync

```ruby
rsync_install 'default'
```

### Remove rsync

```ruby
rsync_install 'default' do
  action :remove
end
```
