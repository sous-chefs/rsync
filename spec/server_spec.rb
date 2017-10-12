require 'spec_helper'

describe 'rsync::server' do
  before :each do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('/etc/rsyncd.conf').and_return(true)
  end

  {
    '6.8' => %i(upstart redhat),
    '7.4.1708' => %i(redhat systemd),
  }.each do |os_version, service_providers|
    context "on rhel #{os_version}" do
      before do
        mock_service_resource_providers(service_providers)
      end

      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'centos',
          platform_family: 'rhel',
          version: os_version
        ).converge('rsync::server')
      end

      it 'includes the default recipe' do
        expect(chef_run).to include_recipe('rsync::default')
      end

      context '/etc/init.d/rsyncd template' do
        let(:template) { chef_run.template('/etc/init.d/rsyncd') }

        case os_version
        when /^6/
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
        else
          it 'not to write template' do
            expect(chef_run).not_to render_file('/etc/init.d/rsyncd')
          end
        end
      end
      context 'rsyncd services' do
        service_name = os_version =~ /^6/ ? 'rsyncd' : 'rsyncd.socket'
        it "starts and enables the #{service_name} service" do
          expect(chef_run).to enable_service(service_name)
        end
      end
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
end
