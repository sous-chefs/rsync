




# expand snake_case to spaces
def snake_to_space(string)
  string.to_s.gsub(/_/, " ")
end

#
# Walk collection for :add rsync_serve resources
# Build and write the config template
# 
def write_conf

  attr_keys=%w/path comment read_only write_only list uid gid auth_users secrets_file hosts_allow
              hosts_deny max_connections munge_symlinks use_chroot numeric_ids fake_super 
              exclude_from exclude include_from include strict_modes log_file log_format 
              transfer_logging timeout dont_compress/

  # Walk the collection, and build a new hash of RsyncServe resources
  # We will use this hash to build up a template for rsyncd.conf
  rsync_modules = Hash.new 
  run_context.resource_collection.each do |resource|
    if resource.is_a? Chef::Resource::RsyncServe and 
       resource.config_path == new_resource.config_path and
       resource.action == :add 

      rsync_modules[resource.name] ||= Hash.new
      # There has to be a better way to get at teh defined attributes
      # for a resource
      attr_keys.each do |key| 
        value = resource.send(key)
        next if value.blank?
        rsync_modules[resource.name][snake_to_space(key)] = value 
      end
    end
  end

  # hackish way to pull notifications up into the current resource in LWRP
  r = ruby_block "updated_by_last_resource" do
    block do new_resource.updated_by_last_action  true end
    action :nothing
  end 

  global_opts = Hash.new
  node[:rsyncd][:globals].each do |key, value|
    next if value.blank?
    global_opts[snake_to_space(key)] = value
  end

  # TODO: make rsyncd globals a better interface than just attributes? 
  # dunno think the current way is a bit of a cludge (attribute/LWRP mixed)
  template new_resource.config_path do
    source "rsyncd.conf.erb"
    owner "root"
    group "root"
    mode  0640
    variables(
      # globals
      :globals => global_opts,
      :modules => rsync_modules
    )
    notifies :restart, "service[rsyncd]", :delayed
    notifies :create, "ruby_block[updated_by_last_resource]", :immediate
  end
end

action :add do 
 write_conf
end

action :remove do 
 write_conf
end
