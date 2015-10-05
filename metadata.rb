name              'rsync'
maintainer        'Chef Software, Inc.'
maintainer_email  'cookbooks@chef.io'
license           'Apache 2.0'
description       'Installs rsync'
version           '0.8.9'

recipe 'rsync::default', 'Installs rsync, Provides LWRP rsync_serve for serving paths via rsyncd'
recipe 'rsync::server', 'Installs rsync and starts a service to serve a directory'

%w(amazon centos centos fedora oracle redhat scientific ubuntu).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/rsync' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/rsync/issues' if respond_to?(:issues_url)
