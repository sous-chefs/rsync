# frozen_string_literal: true

apt_update 'update' if platform_family?('debian')

rsync_install 'default'

rsync_service 'default'

rsync_serve 'foo' do
  path '/foo'
end

rsync_serve 'tmp' do
  path '/tmp'
end
