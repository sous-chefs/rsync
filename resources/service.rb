# frozen_string_literal: true

provides :rsync_service
unified_mode true

property :config_path, String, default: '/etc/rsyncd.conf'
property :defaults_file, String
property :options, String, default: ''
property :service_name, String

default_action :create

action :create do
  systemd_unit "#{resolved_service_name}.service" do
    content <<~UNIT
      [Unit]
      Description=fast remote file copy program daemon
      ConditionPathExists=#{new_resource.config_path}

      [Service]
      EnvironmentFile=#{resolved_defaults_file}
      ExecStart=/usr/bin/rsync --daemon --no-detach --config #{new_resource.config_path} "$OPTIONS"

      [Install]
      WantedBy=multi-user.target
    UNIT
    notifies :restart, "service[#{resolved_service_name}]", :delayed
    action :create
  end

  template resolved_defaults_file do
    source 'rsync-defaults.erb'
    cookbook 'rsync'
    owner 'root'
    group 'root'
    mode '0644'
    variables(options: new_resource.options)
    notifies :restart, "service[#{resolved_service_name}]", :delayed
  end

  service resolved_service_name do
    action [:enable, :start]
  end
end

action :delete do
  service resolved_service_name do
    action [:stop, :disable]
  end

  systemd_unit "#{resolved_service_name}.service" do
    action :delete
  end

  file resolved_defaults_file do
    action :delete
  end
end

action :start do
  service resolved_service_name do
    action :start
  end
end

action :stop do
  service resolved_service_name do
    action :stop
  end
end

action :restart do
  service resolved_service_name do
    action :restart
  end
end

action_class do
  include Rsync::Cookbook::Helpers

  def resolved_service_name
    new_resource.service_name || rsync_service_name
  end

  def resolved_defaults_file
    new_resource.defaults_file || rsync_defaults_file
  end
end
