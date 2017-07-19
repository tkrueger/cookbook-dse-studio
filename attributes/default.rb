

default['dse']['studio']['version'] = '2.0.0'
default['dse']['studio']['download_url'] = "http://#{node['dse']['studio']['repo_user']}:#{node['dse']['studio']['repo_pass']}@downloads.datastax.com/enterprise/datastax-studio-#{node['dse']['studio']['version']}.tar.gz"
default['dse']['studio']['download_to'] = '/tmp'
default['dse']['studio']['user'] = 'dse'
default['dse']['studio']['group'] = 'dse'
default['dse']['studio']['install_dir'] = "/home/#{node['dse']['studio']['user']}"
default['dse']['studio']['repo_user'] = nil
default['dse']['studio']['repo_pass'] = nil

default['dse']['studio']['service_template'] = 'dse_studio.service.erb'
default['dse']['studio']['configuration_template'] = 'configuration.yaml.erb'
default['dse']['studio']['template_cookbook'] = 'dse_studio'
default['dse']['studio']['startup_params'] = ''

default['dse']['studio']['result_set_size_limit'] = 1000
default['dse']['studio']['max_result_size_bytes'] = 10485760
default['dse']['studio']['execution_timeout_ms'] = 0
default['dse']['studio']['schema_refresh_interval_ms'] = 3000
default['dse']['studio']['traversal_sources']['real_time_traversal_source'] = 'g'
default['dse']['studio']['traversal_sources']['analytic_traversal_source'] = 'a'
default['dse']['studio']['http_port'] = 9091
default['dse']['studio']['http_bind_address'] = 'localhost'
default['dse']['studio']['logging']['file_name'] = 'studio.log'
default['dse']['studio']['logging']['max_file_size'] = '250 MB'
default['dse']['studio']['logging']['max_files'] = 10
default['dse']['studio']['logging']['directory'] = './logs'
default['dse']['studio']['security']['encryption_password_file'] = 'conf/security/security.properties'

default['dse']['studio']['user_data']['base_directory'] = 'null'
default['dse']['studio']['user_data']['connections_directory'] = 'connections'
default['dse']['studio']['user_data']['notebooks_directory'] = 'notebooks'

default['dse']['studio']['connection_management']['idle_timeout_in_seconds'] = 3600
default['dse']['studio']['connection_management']['ide']['connection']['service_port'] = 9091
default['dse']['studio']['connection_management']['ide']['connection']['cache_idle_time_in_seconds'] = 3600
default['dse']['studio']['connection_management']['ide']['connection']['config_monitor_frequency_in_seconds'] = 120
default['dse']['studio']['connection_management']['ide']['file']['service_port'] = 9091
default['dse']['studio']['connection_management']['ide']['file']['contents_json_field'] = 'code'
default['dse']['studio']['connection_management']['ide']['graph_schema_chache_idle_time_in_seconds'] = 600
