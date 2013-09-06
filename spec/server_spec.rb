require 'spec_helper'

describe 'rsync::server' do
  context 'on rhel' do
    let(:chef_run) do
      ChefSpec::ChefRunner.new(platform: 'redhat', version: '6.3').converge('rsync::server')
    end

    it 'includes the default recipe' do
      expect(chef_run).to include_recipe('rsync::default')
    end

    context '/etc/init.d/rsyncd template' do
      let(:template) { chef_run.template('/etc/init.d/rsyncd') }

      it 'writes the template' do
        expect(chef_run).to create_file_with_content('/etc/init.d/rsyncd', 'Rsyncd init script')
      end

      it 'is owned by root:root' do
        expect(template.owner).to eq('root')
        expect(template.group).to eq('root')
      end

      it 'has the correct permissions' do
        expect(template.mode).to eq('0755')
      end
    end

    it 'starts and enables the rsync service' do
      expect(chef_run).to set_service_to_start_on_boot('rsyncd')
    end
  end

  context 'on debian' do
    let(:chef_run) do
      ChefSpec::ChefRunner.new(platform: 'ubuntu', version: '12.04').converge('rsync::server')
    end

    it 'includes the default recipe' do
      expect(chef_run).to include_recipe('rsync::default')
    end

    context '/etc/default/rsync template' do
      let(:template) { chef_run.template('/etc/default/rsync') }

      it 'writes the template' do
        expect(chef_run).to create_file_with_content('/etc/default/rsync', 'defaults file for rsync daemon mode')
      end

      it 'is owned by root:root' do
        expect(template.owner).to eq('root')
        expect(template.group).to eq('root')
      end

      it 'has the correct permissions' do
        expect(template.mode).to eq('0644')
      end
    end

    it 'starts and enables the rsync service' do
      expect(chef_run).to set_service_to_start_on_boot('rsync')
    end
  end
end
