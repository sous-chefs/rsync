Description
===========

Requirements
============


Attributes
==========
* default[:rsync][:daemon] = "false"
* default[:rsync][:rsyncd_conf] = "/etc/rsyncd.conf"
* default[:rsync][:rsyncd_opts] = ""
* default[:rsync][:rsynd_nice] = ""

Set the node[:rsync][:daemon] = "true" to enable the rsync daemon.
Other parameters are all default settings for rsync.  Please see
/etc/defaults/rsync for details on each setting.

Recipes
=======
* default.rb


default
-------

Resources/Providers
===================

Usage
=====

Examples
--------

License and Author
==================

Author:: AUTHOR_NAME

Copyright:: YYYY, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
