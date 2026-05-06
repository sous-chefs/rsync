# frozen_string_literal: true

require 'spec_helper'

describe 'rsync_install' do
  step_into :rsync_install
  platform 'ubuntu', '24.04'

  context 'with default properties' do
    recipe do
      rsync_install 'default'
    end

    it { is_expected.to install_package('rsync') }
  end

  context 'with action :create' do
    recipe do
      rsync_install 'default' do
        action :create
      end
    end

    it { is_expected.to install_package('rsync') }
  end

  context 'with action :remove' do
    recipe do
      rsync_install 'default' do
        action :remove
      end
    end

    it { is_expected.to remove_package('rsync') }
  end

  context 'with action :delete' do
    recipe do
      rsync_install 'default' do
        action :delete
      end
    end

    it { is_expected.to remove_package('rsync') }
  end
end
