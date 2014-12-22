require 'spec_helper'

describe 'rsync::server' do
  context 'on rhel' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'redhat', version: '6.3').converge(described_recipe)
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

    context "config file exists" do
      before do
        allow(File).to receive(:exists?).and_call_original
        allow(File).to receive(:exists?).with(chef_run.node.rsyncd.config).and_return(true)
        chef_run.converge(described_recipe)
      end

      it 'starts and enables the rsync service' do
        expect(chef_run).to enable_service('rsyncd')
        expect(chef_run).to start_service('rsyncd')
      end
    end
  end

  context 'on debian' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04').converge(described_recipe)
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

    context "config file exists" do
      before do
        allow(File).to receive(:exists?).and_call_original
        allow(File).to receive(:exists?).with(chef_run.node.rsyncd.config).and_return(true)
        chef_run.converge(described_recipe)
      end

      it 'starts and enables the rsync service' do
        expect(chef_run).to enable_service('rsync')
        expect(chef_run).to start_service('rsync')
      end
    end
  end
end
