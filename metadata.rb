name              'rsync'
maintainer        'Opscode, Inc.'
maintainer_email  'cookbooks@opscode.com'
license           'Apache 2.0'
description       'Installs rsync'
version           '0.8.6'

recipe 'rsync::default', 'Installs rsync, Provides LWRP rsync_serve for serving paths via rsyncd'
recipe 'rsync::server', 'Installs rsync and starts a service to serve a directory'

%w(centos fedora redhat ubuntu debian).each do |os|
  supports os
end
