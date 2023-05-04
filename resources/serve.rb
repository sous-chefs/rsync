unified_mode true

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

action :add do
  write_conf
end

action :remove do
  write_conf
end

action_class do
  #
  # Walk collection for :add rsync_serve resources
  # Build and write the config template
  #
  def write_conf
    template(new_resource.config_path) do
      source   'rsyncd.conf.erb'
      cookbook 'rsync'
      owner    'root'
      group    'root'
      mode     '0640'
      variables(
        globals: global_modules,
        modules: rsync_modules
      )
      notifies :restart, "service[#{rsync_service_name}]", :delayed
    end

    service rsync_service_name do
      action :nothing
    end
  end

  # The list of attributes for this resource.
  #
  # @todo find a better way to do this
  #
  # @return [Array<String>]
  def resource_attributes
    %w(
      auth_users
      comment
      dont_compress
      exclude
      exclude_from
      fake_super
      gid
      hosts_allow
      hosts_deny
      include
      include_from
      incoming_chmod
      list
      lock_file
      log_file
      log_format
      max_connections
      munge_symlinks
      numeric_ids
      outgoing_chmod
      path
      postxfer_exec
      prexfer_exec
      read_only
      refuse_options
      secrets_file
      strict_modes
      timeout
      transfer_logging
      uid
      use_chroot
      write_only
    )
  end

  # The list of rsync server resources in the resource collection
  #
  # @return [Array<Chef::Resource>]
  def rsync_resources
    ::ObjectSpace.each_object(::Chef::Resource).select do |resource|
      resource.resource_name == :rsync_serve
    end
  end

  # Perform replacement on specific (un)hyphenated config directives.
  #
  # @param [String] string
  #
  # @return [String]
  def unhyphenate(string)
    string.to_s.gsub(/(pre|post)xfer/, '\1-xfer')
  end

  # Expand "snake_case_things" to "snake case things".
  #
  # @param [String] string
  #
  # @return [String]
  def snake_to_space(string)
    string.to_s.tr('_', ' ')
  end

  # Converts a provider attribute to an rsync config directive.
  #
  # @param [String] string
  #
  # @return [String]
  def attribute_to_directive(string)
    unhyphenate(snake_to_space(string))
  end

  # The list of rsync modules defined in the resource collection.
  #
  # @return [Hash]
  def rsync_modules
    rsync_resources.each_with_object({}) do |resource, hash|
      next unless resource.config_path == new_resource.config_path && (
        resource.action == :add ||
        resource.action.include?(:add)
      )
      hash[resource.name] ||= {}
      resource_attributes.each do |key|
        value = resource.send(key)
        next if value.nil?
        hash[resource.name][attribute_to_directive(key)] = value
      end
    end
  end

  # The global rsync configuration
  #
  # @return [Hash]
  def global_modules
    node['rsyncd']['globals'].each_with_object({}) do |(key, value), hash|
      hash[attribute_to_directive(key)] = value unless value.nil?
    end
  end
end
