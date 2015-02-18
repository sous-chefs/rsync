require 'spec_helper'

describe 'rsync::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04').converge(described_recipe)
  end

  it 'installs the rsync package' do
    expect(chef_run).to install_package('rsync')
  end
end
