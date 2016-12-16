#
# Installs DSE Studio from datastax download page
#

repo_user = node['dse']['studio']['repo_user']
repo_pass = node['dse']['studio']['repo_pass']

raise "need to set node['dse']['studio']['repo_user']" unless repo_user
raise "need to set node['dse']['studio']['repo_pass']" unless repo_pass

#
install_dir = "#{node['dse']['studio']['install_dir']}/datastax-studio-#{node['dse']['studio']['version']}"
studio_tarball = "#{node['dse']['studio']['download_to']}/datastax-studio-#{node['dse']['studio']['version']}.tar.gz"

#
# Prepare studio user
#

user node['dse']['studio']['user'] do
  comment "DSE Studio user"
  system true
end

group node['dse']['studio']['group'] do
  action :create
  members node['dse']['studio']['user']
  append true
end

directory node['dse']['studio']['install_dir'] do
  action :create
  recursive true
  owner node['dse']['studio']['user']
  group node['dse']['studio']['group']
end

#
# Install Studio from Tarball
#

Chef::Log.info("downloading tarball from #{node['dse']['studio']['download_url']}")
Chef::Log.info("downloading tarball to #{studio_tarball}")

tar_extract node['dse']['studio']['download_url'] do
  download_dir '/tmp/'
  target_dir node['dse']['studio']['install_dir']
  creates "#{node['dse']['studio']['install_dir']}/datastax-studio-#{node['dse']['studio']['version']}/bin/server.sh"
  user node['dse']['studio']['user']
  #tar_flags [ '-P', '--strip-components 1' ]
end

#
# Configure
#

template "#{install_dir}/conf/configuration.yaml" do
  source node['dse']['studio']['configuration_template']
  cookbook node['dse']['studio']['template_cookbook']
  user node['dse']['studio']['user']
  group node['dse']['studio']['group']
  action :create
  notifies :restart, 'service[dse_studio]'
end

#
# Install Service dse_studio
#

template '/etc/systemd/system/dse_studio.service' do
  source node['dse']['studio']['service_template']
  cookbook node['dse']['studio']['template_cookbook']
  action :create
  notifies :restart, 'service[dse_studio]'
end

service 'dse_studio' do
  action [ :enable, :start ]
end
