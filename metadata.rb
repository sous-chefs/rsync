name              "rsync"
maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs rsync"
version           "0.7.1"


recipe "rsync", "Installs rsync, Provides LWRP rsync_serve for serivng pats via rsyncd"

%w{ centos fedora redhat ubuntu debian }.each do |os|
  supports os
end
