module Rsync
  module Cookbook
    module Helpers
      def rsync_service_name
        if platform_family?('debian')
          'rsync'
        else
          'rsyncd'
        end
      end

      def rsync_defaults_file
        if platform_family?('debian')
          '/etc/default/rsync'
        else
          '/etc/sysconfig/rsyncd'
        end
      end
    end
  end
end
Chef::DSL::Recipe.include ::Rsync::Cookbook::Helpers
Chef::Resource.include ::Rsync::Cookbook::Helpers
