name              "rsync"
maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs rsync and provides resources for file distribution."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.9.0"

recipe "rsync", "Installs rsync, provides LWRP for both rsync_server and for executing client rsync operations"

%w{ centos fedora redhat ubuntu debian }.each do |os|
  supports os
end
