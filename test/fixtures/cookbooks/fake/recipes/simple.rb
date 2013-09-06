include_recipe 'rsync::server'

rsync_serve 'tmp' do
  path '/tmp'
end
