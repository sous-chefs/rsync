name              'rsync'
maintainer        'Chef Software, Inc.'
maintainer_email  'cookbooks@chef.io'
license           'Apache-2.0'
description       'Installs rsync'
version '1.1.0'

%w(amazon centos centos fedora oracle redhat scientific ubuntu).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/rsync'
issues_url 'https://github.com/chef-cookbooks/rsync/issues'
chef_version '>= 13'
