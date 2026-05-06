# frozen_string_literal: true

require 'spec_helper'

describe 'rsync_serve' do
  step_into :rsync_serve
  platform 'ubuntu', '24.04'

  context 'with default properties' do
    recipe do
      service 'rsync' do
        action :nothing
      end

      rsync_serve 'foo' do
        path '/foo'
      end

      rsync_serve 'tmp' do
        path '/tmp'
      end
    end

    it { is_expected.to create_template('/etc/rsyncd.conf') }

    it 'renders all modules in the same config file' do
      modules = chef_run.template('/etc/rsyncd.conf').variables[:modules]

      expect(modules['foo']['path']).to eq('/foo')
      expect(modules['tmp']['path']).to eq('/tmp')
    end
  end

  context 'with globals and module options' do
    recipe do
      service 'rsync' do
        action :nothing
      end

      rsync_serve 'centos-prod' do
        globals(
          'motd_file' => '/etc/rsync.motd',
          'socket options' => 'SO_KEEPALIVE'
        )
        path '/data/repos/prod/centos'
        comment 'CentOS prod mirror'
        read_only true
        use_chroot true
        list true
        uid 'nobody'
        gid 'nobody'
        hosts_allow '127.0.0.1, 10.4.1.0/24, 192.168.4.0/24'
        hosts_deny '0.0.0.0/0'
        max_connections 10
        transfer_logging true
        log_file '/tmp/centos-sync'
        prexfer_exec '/bin/true'
        postxfer_exec '/bin/true'
        incoming_chmod 'a=r,u+w,D+x'
        outgoing_chmod 'a=r,u+w,D+x'
      end
    end

    it { is_expected.to create_template('/etc/rsyncd.conf') }

    it 'renders globals and rsync directives' do
      expect(chef_run).to render_file('/etc/rsyncd.conf').with_content(%r{motd file = /etc/rsync\.motd})
      expect(chef_run).to render_file('/etc/rsyncd.conf').with_content(/socket options = SO_KEEPALIVE/)
      expect(chef_run).to render_file('/etc/rsyncd.conf').with_content(/read only = true/)
      expect(chef_run).to render_file('/etc/rsyncd.conf').with_content(%r{pre-xfer exec = /bin/true})
      expect(chef_run).to render_file('/etc/rsyncd.conf').with_content(%r{post-xfer exec = /bin/true})
      expect(chef_run).to render_file('/etc/rsyncd.conf').with_content(/incoming chmod = a=r,u\+w,D\+x/)
      expect(chef_run).to render_file('/etc/rsyncd.conf').with_content(/outgoing chmod = a=r,u\+w,D\+x/)
    end
  end

  context 'with action :remove' do
    recipe do
      service 'rsync' do
        action :nothing
      end

      rsync_serve 'tmp' do
        path '/tmp'
        action :remove
      end
    end

    it 'removes the module from the rendered config' do
      expect(chef_run.template('/etc/rsyncd.conf').variables[:modules]).to be_empty
    end
  end
end
