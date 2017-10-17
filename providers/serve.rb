
#
# Cookbook:: rsync
# Provider:: serve
#
# Copyright:: 2012-2016, Chef Software, Inc.
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

# we are not using inline resources on purpose here as it breaks
# the accumulator pattern this cookbook implements

use_inline_resources

action :add do # ~FC017
  write_conf
end

action :remove do # ~FC017
  write_conf
end

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
    notifies :restart, "service[#{node['rsyncd']['service']}]", :delayed
  end

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
