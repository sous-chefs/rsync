require 'spec_helper'

describe 'rsync::server' do
  before :each do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('/etc/rsyncd.conf').and_return(true)
  end

  context 'on rhel' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '8').converge('rsync::server')
    end

    it 'includes the default recipe' do
      expect(chef_run).to include_recipe('rsync::default')
    end

    it 'starts and enables the rsync service' do
      expect(chef_run).to enable_service('rsyncd')
    end
  end

  context 'on debian' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '20.04').converge('rsync::server')
    end

    it 'includes the default recipe' do
      expect(chef_run).to include_recipe('rsync::default')
    end

    context '/etc/default/rsync template' do
      let(:template) { chef_run.template('/etc/default/rsync') }

      it 'writes the template' do
        expect(chef_run).to render_file('/etc/default/rsync').with_content('defaults file for rsync daemon mode')
      end
    end

    it 'starts and enables the rsync service' do
      expect(chef_run).to enable_service('rsync')
    end
  end
  context 'on amazon' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'amazon', version: '2').converge('rsync::server')
    end

    it 'includes the default recipe' do
      expect(chef_run).to include_recipe('rsync::default')
    end

    it 'starts and enables the rsync service' do
      expect(chef_run).to enable_service('rsyncd')
    end
  end
end
