#
# Rsync Server Module Resource
#
# Recipe:: rsync
# Resource:: serve
#
#

default_action :add

# man rsyncd.conf for more info on each attribute

attribute :config_path, kind_of: String, default: '/etc/rsyncd.conf'
attribute :path, kind_of: String, required: true
attribute :comment, kind_of: String
attribute :read_only, kind_of: [true, false]
attribute :write_only, kind_of: [true, false]
attribute :list, kind_of: [true, false]
attribute :uid, kind_of: String
attribute :gid, kind_of: String
attribute :auth_users, kind_of: String
attribute :secrets_file, kind_of: String
attribute :hosts_allow, kind_of: String
attribute :hosts_deny, kind_of: String
attribute :max_connections, kind_of: Integer, default: 0
attribute :munge_symlinks, kind_of: [TrueClass, FalseClass], default: true
attribute :use_chroot, kind_of: [true, false]
attribute :numeric_ids, kind_of: [TrueClass, FalseClass], default: true
attribute :fake_super, kind_of: [true, false]
attribute :exclude_from, kind_of: String
attribute :exclude, kind_of: String
attribute :include_from, kind_of: String
attribute :include, kind_of: String
attribute :strict_modes, kind_of: [true, false]
attribute :log_file, kind_of: String
attribute :log_format, kind_of: String
attribute :transfer_logging, kind_of: [true, false]
# by default rsync sets no client timeout (lets client choose, but this is a trivial DOS) so we make a 10 minute one
attribute :timeout, kind_of: Integer, default: 600
attribute :dont_compress, kind_of: String
attribute :lock_file, kind_of: String
attribute :refuse_options, kind_of: String
attribute :prexfer_exec, kind_of: String
attribute :postxfer_exec, kind_of: String
attribute :incoming_chmod, kind_of: String
attribute :outgoing_chmod, kind_of: String
