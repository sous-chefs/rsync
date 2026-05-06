# frozen_string_literal: true

require 'spec_helper'

describe Rsync::Cookbook::Helpers do
  subject(:helper) do
    Class.new do
      include Rsync::Cookbook::Helpers

      attr_writer :platform_family

      def platform_family?(*families)
        families.include?(@platform_family)
      end
    end.new
  end

  context 'on Debian family platforms' do
    before { helper.platform_family = 'debian' }

    it 'uses the Debian service name' do
      expect(helper.rsync_service_name).to eq('rsync')
    end

    it 'uses the Debian defaults file' do
      expect(helper.rsync_defaults_file).to eq('/etc/default/rsync')
    end
  end

  context 'on non-Debian platforms' do
    before { helper.platform_family = 'rhel' }

    it 'uses the rsyncd service name' do
      expect(helper.rsync_service_name).to eq('rsyncd')
    end

    it 'uses the sysconfig defaults file' do
      expect(helper.rsync_defaults_file).to eq('/etc/sysconfig/rsyncd')
    end
  end
end
