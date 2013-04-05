default['rsync']['server']['role'] = 'management'
default['rsync']['preferred_network_interface'] = 'eth0'
default['rsync']['server']['src_root'] = '/usr/src'
default['rsync']['client']['vhosts'] = 'this needs to be an array'





=begin
Notes:

vhosts for server attributes example:

  {"src_root":"/usr/src","vhosts":[{"vhost":"webdata","server":"","branch":"","key":""},{"vhost":"haproxy","server":"http://git.1wt.eu/git/haproxy.git","branch":"v1.5-dev10"},{"vhost":"percona","server":"","branch":""},{"vhost":"daemons","server":"","branch":"","key":""},{"vhost":"cxyz_website","server":"","branch":"","key":""},{"vhost":"php","server":"https://github.com/php/php-src.git","branch":"PHP-5.4.10"},{"vhost":"stud","server":"https://github.com/bumptech/stud.git","branch":"master"},{"vhost":"phpcouchbase","server":"git://github.com/couchbase/php-ext-couchbase.git","branch":"1.1.1"},{"vhost":"libcouchbase","server":"git://github.com/couchbase/libcouchbase.git","branch":"master"},{"branch":"","vhost":"daemons","key":"","server":""},{"branch":"","vhost":"global_includes","key":"","server":""},{"branch":"","vhost":"sqlupdates","key":"","server":""},{"branch":"","vhost":"legacy_hosts_files","key":"","server":""}]}

=end

=begin
vhosts for client attributes example:


{"client":{"vhosts":[{"vhost":"haproxy","destination":"/var/cache/chef/haproxy"},{"vhost":"stud","destination":"/var/cache/chef/stud"}]}}

there's a delete param when set to true will cause the rsync client to be invoked with --delete (be careful dude.)

=end

