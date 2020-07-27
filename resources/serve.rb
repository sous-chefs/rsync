#
# Rsync Server Module Resource
#
# Recipe:: rsync
# Resource:: serve
#
#

default_action :add

# man rsyncd.conf for more info on each property

property :config_path, String, default: '/etc/rsyncd.conf'
property :path, String, required: true
property :comment, String
property :read_only, [true, false]
property :write_only, [true, false]
property :list, [true, false]
property :uid, String
property :gid, String
property :auth_users, String
property :secrets_file, String
property :hosts_allow, String
property :hosts_deny, String
property :max_connections, Integer, default: 0
property :munge_symlinks, [true, false], default: true
property :use_chroot, [true, false]
property :numeric_ids, [true, false], default: true
property :fake_super, [true, false]
property :exclude_from, String
property :exclude, String
property :include_from, String
property :include, String
property :strict_modes, [true, false]
property :log_file, String
property :log_format, String
property :transfer_logging, [true, false]
# by default rsync sets no client timeout (lets client choose, but this is a trivial DOS) so we make a 10 minute one
property :timeout, Integer, default: 600
property :dont_compress, String
property :lock_file, String
property :refuse_options, String
property :prexfer_exec, String
property :postxfer_exec, String
property :incoming_chmod, String
property :outgoing_chmod, String
