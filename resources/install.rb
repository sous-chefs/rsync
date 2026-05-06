# frozen_string_literal: true

provides :rsync_install
unified_mode true

property :package_name, [String, Array], default: 'rsync'

default_action :install

action :install do
  install_rsync_package
end

action :create do
  install_rsync_package
end

action :remove do
  remove_rsync_package
end

action :delete do
  remove_rsync_package
end

action_class do
  def install_rsync_package
    package new_resource.package_name do
      action :install
    end
  end

  def remove_rsync_package
    package new_resource.package_name do
      action :remove
    end
  end
end
