# frozen_string_literal: true

require 'spec_helper'

describe 'rsync_service' do
  step_into :rsync_service

  context 'on Ubuntu' do
    platform 'ubuntu', '24.04'

    recipe do
      rsync_service 'default' do
        options '--port=8873'
      end
    end

    it { is_expected.to create_systemd_unit('rsync.service') }
    it { is_expected.to create_template('/etc/default/rsync').with(variables: { options: '--port=8873' }) }
    it { is_expected.to enable_service('rsync') }
    it { is_expected.to start_service('rsync') }
  end

  context 'on AlmaLinux' do
    platform 'almalinux', '9'

    recipe do
      rsync_service 'default'
    end

    it { is_expected.to create_systemd_unit('rsyncd.service') }
    it { is_expected.to create_template('/etc/sysconfig/rsyncd').with(variables: { options: '' }) }
    it { is_expected.to enable_service('rsyncd') }
    it { is_expected.to start_service('rsyncd') }
  end

  context 'with action :delete' do
    platform 'ubuntu', '24.04'

    recipe do
      rsync_service 'default' do
        action :delete
      end
    end

    it { is_expected.to stop_service('rsync') }
    it { is_expected.to disable_service('rsync') }
    it { is_expected.to delete_systemd_unit('rsync.service') }
    it { is_expected.to delete_file('/etc/default/rsync') }
  end
end
