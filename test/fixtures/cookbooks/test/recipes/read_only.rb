apt_update 'update' if platform_family?('debian')

include_recipe 'rsync::server'

rsync_serve 'tmp' do
  path      '/tmp'
  uid       'nobody'
  gid       'nobody'
  read_only true
end
