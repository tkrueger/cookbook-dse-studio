require 'spec_helper'

describe 'dse_studio::studio' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.override['dse']['studio']['version'] = '2.0.0'
      node.override['dse']['studio']['repo_user'] = 'some_user'
      node.override['dse']['studio']['repo_pass'] = 'some_password'
    end.converge(described_recipe)
   end

  it 'downloads a tarfile' do
    expect(chef_run).to extract_tar_extract('http://some_user:some_password@downloads.datastax.com/enterprise/datastax-studio-2.0.0.tar.gz')
  end

  it 'creates user and group' do
    expect(chef_run).to create_user('dse')
    expect(chef_run).to create_group('dse').with(members: ['dse'])
  end

  it 'configures the service' do
    expect(chef_run).to enable_service('dse_studio')
    expect(chef_run).to start_service('dse_studio')
  end

  it 'creates dse studio service' do
    expect(chef_run).to create_template('/etc/systemd/system/dse_studio.service')
  end
end
