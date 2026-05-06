# rsync_install

Installs or removes the rsync package.

## Actions

| Action     | Description                                  |
|------------|----------------------------------------------|
| `:install` | Installs the rsync package. Default action.  |
| `:create`  | Alias for `:install`.                        |
| `:remove`  | Removes the rsync package.                   |
| `:delete`  | Alias for `:remove`.                         |

## Properties

| Property       | Type            | Default   | Description                  |
|----------------|-----------------|-----------|------------------------------|
| `package_name` | String or Array | `'rsync'` | Package name or names to use. |

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
