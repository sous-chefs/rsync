require 'spec_helper'

describe 'rsync::default' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge('rsync::default')
  end

  it 'installs the rsync package' do
    expect(chef_run).to install_package('rsync')
  end
end
