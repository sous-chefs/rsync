# frozen_string_literal: true

apt_update 'update' if platform_family?('debian')

rsync_install 'default'

rsync_service 'default'

rsync_serve 'tmp' do
  path '/tmp'
  uid 'nobody'
  gid 'nobody'
  read_only true
end
