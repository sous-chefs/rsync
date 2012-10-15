Description
===========

Requirements
============


Attributes
==========

Recipes
=======

default
-------

Resources/Providers
===================

Usage
=====
/usr/bin/rsync --stats --links --recursive --times --compress --bwlimit=360 --exclude CVS --exclude .svn --delete-after cpan.pair.com::CPAN /backup/mirror/cpan
/usr/bin/rsync --stats --links --recursive --times --compress --bwlimit=360 --exclude .svn --exclude CVS --delete-after rsync://mysql.mirrors.pair.com/mysql /backup/mirror/mysql
/usr/bin/rsync --archive --safe-links --compress --bwlimite=360 --exclude CVS --exclude .svn --delete-after rsync.apache.org::apache-dist /backup/mirror/apache
/usr/bin/rsync --links --recursive --times --compress --bwlimit=360 --exclude .svn --exclude CVS --delete-after download.eclipse.org::eclipseMirror /home/cerebrus/public_html/mirror/eclipse
/usr/bin/rsync --stats --links --recursive --times --stats --compress --bwlimit=360 --exclude .svn --exclude CVS --delete-after rsync.mozdev.org::mozdev /backup/mirror/mozdev


Examples
--------

License and Author
==================

Author:: Stathy G. Touloumis

Copyright:: 2012, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
