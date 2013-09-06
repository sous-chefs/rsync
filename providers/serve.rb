#
# Cookbook Name:: rsync
# Provider:: serve
#
# Copyright 2012-2013, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
#

action :add do
  write_conf
end

action :remove do
  write_conf
end

protected
  #
  # Walk collection for :add rsync_serve resources
  # Build and write the config template
  #
  def write_conf
    t = template(new_resource.config_path) do
      source   'rsyncd.conf.erb'
      cookbook 'rsync'
      owner    'root'
      group    'root'
      mode     '0640'
      variables(
        :globals => global_modules,
        :modules => rsync_modules
      )
      notifies :restart, "service[#{node['rsyncd']['service']}]", :delayed
    end

    new_resource.updated_by_last_action(t.updated?)

    service node['rsyncd']['service'] do
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
      list
      lock_file
      log_file
      log_format
      max_connections
      munge_symlinks
      numeric_ids
      path
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
    run_context.resource_collection.select do |resource|
      resource.is_a?(Chef::Resource::RsyncServe)
    end
  end

  # Expand "snake_case_things" to "snake case things".
  #
  # @param [String] string
  #
  # @return [String]
  def snake_to_space(string)
    string.to_s.gsub(/_/, ' ')
  end

  # The list of rsync modules defined in the resource collection.
  #
  # @return [Hash]
  def rsync_modules
    rsync_resources.reduce({}) do |hash, resource|
      if resource.config_path == new_resource.config_path && resource.action == :add
        hash[resource.name] ||= {}
        resource_attributes.each do |key|
          value = resource.send(key)
          next if value.nil?
          hash[resource.name][snake_to_space(key)] = value
        end
      end

      hash
    end
  end

  # The global rsync configuration
  #
  # @return [Hash]
  def global_modules
    node['rsyncd']['globals'].reduce({}) do |hash, (key, value)|
      hash[snake_to_space(key)] = value unless value.nil?
      hash
    end
  end
