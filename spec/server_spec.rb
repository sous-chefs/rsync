require 'spec_helper'

describe 'rsync::server' do
  before :each do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('/etc/rsyncd.conf').and_return(true)
  end

  context 'on rhel' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.9').converge('rsync::server')
    end

    it 'includes the default recipe' do
      expect(chef_run).to include_recipe('rsync::default')
    end

    context '/etc/init.d/rsyncd template' do
      let(:template) { chef_run.template('/etc/init.d/rsyncd') }

      it 'writes the template' do
        expect(chef_run).to render_file('/etc/init.d/rsyncd').with_content('Rsyncd init script')
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
      expect(chef_run).to enable_service('rsyncd')
    end
  end

  context 'on debian' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge('rsync::server')
    end

    it 'includes the default recipe' do
      expect(chef_run).to include_recipe('rsync::default')
    end

    context '/etc/default/rsync template' do
      let(:template) { chef_run.template('/etc/default/rsync') }

      it 'writes the template' do
        expect(chef_run).to render_file('/etc/default/rsync').with_content('defaults file for rsync daemon mode')
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
      expect(chef_run).to enable_service('rsync')
    end
  end
  context 'on amazon' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'amazon', version: '2016.09').converge('rsync::server')
    end

    it 'includes the default recipe' do
      expect(chef_run).to include_recipe('rsync::default')
    end

    context '/etc/init.d/rsyncd template' do
      let(:template) { chef_run.template('/etc/init.d/rsyncd') }

      it 'writes the template' do
        expect(chef_run).to render_file('/etc/init.d/rsyncd').with_content('Rsyncd init script')
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
      expect(chef_run).to enable_service('rsyncd')
    end
  end
end
