dse_studio Cookbook
===================

This cookbook installs and configures  Datastax Studio. 

## Requirements

### Cookbooks 

#### Recommended

- `java` - a jvm needs to be on the machine for `studio`
- `nginx-proxy` - to easily stand up an nginx ssh reverse proxy for studio. 

### DSE Credentials file

Before being able to run `test-kitchen` tests, you need to create a file `dse_creds.yaml`:

```yaml
repo_user: <your dse username>
repo_pass: <your dse password>
```

This file is read from `.kitchen.yml` during integration tests.

Attributes
----------

 * `node['dse']['studio']['version']` = Version to install ('1.0.1').
 * `node['dse']['studio']['download_url']` = Pattern to build the download URL. ("http://#{node['dse']['studio']['repo_user']}:#{node['dse']['studio']['repo_pass']}@downloads.datastax.com/enterprise/datastax-studio-#{node['dse']['studio']['version']}.tar.gz")
 * `node['dse']['studio']['download_to']` = Where to download to ('/tmp')
 * `node['dse']['studio']['user']` = Name of user to create for running studio ('dse').
 * `node['dse']['studio']['group']` = Name of a group to add the user to ('dse').
 * `node['dse']['studio']['install_dir']` = Where to install ("/home/#{node['dse']['studio']['user']}").
 * `node['dse']['studio']['repo_user']` = Datastax account's username. Will cause error if not set (nil).
 * `node['dse']['studio']['repo_pass']` = Datastax account's password. Will cause error if not set (nil).

 * `node['dse']['studio']['service_template']` = 'dse_studio.service.erb'
 * `node['dse']['studio']['configuration_template']` = 'configuration.yaml.erb'
 * `node['dse']['studio']['template_cookbook']` = 'dse_studio'
 * `node['dse']['studio']['startup_params']` = Additional startup parameters for studio ('').

 * `node['dse']['studio']['result_set_size_limit']` = 1000
 * `node['dse']['studio']['max_result_size_bytes']` = 10485760
 * `node['dse']['studio']['execution_timeout_ms']` = 0
 * `node['dse']['studio']['schema_refresh_interval_ms']` = 3000
 * `node['dse']['studio']['traversal_sources']['real_time_traversal_source']` = 'g'
 * `node['dse']['studio']['traversal_sources']['analytic_traversal_source']` = 'a'
 * `node['dse']['studio']['http_port']` = 9091
 * `node['dse']['studio']['http_bind_address']` = 'localhost'
 * `node['dse']['studio']['logging']['file_name']` = 'studio.log'
 * `node['dse']['studio']['logging']['max_file_size']` = '250 MB'
 * `node['dse']['studio']['logging']['max_files']` = 10
 * `node['dse']['studio']['logging']['directory']` = './logs'
 * `node['dse']['studio']['security']['encryption_password_file']` = 'conf/security/security.properties'

 * `node['dse']['studio']['user_data']['base_directory']` = 'null'
 * `node['dse']['studio']['user_data']['connections_directory']` = 'connections'
 * `node['dse']['studio']['user_data']['notebooks_directory']` = 'notebooks'

 * `node['dse']['studio']['connection_management']['idle_timeout_in_seconds']` = 3600
 * `node['dse']['studio']['connection_management']['ide']['connection']['service_port']` = 9091
 * `node['dse']['studio']['connection_management']['ide']['connection']['cache_idle_time_in_seconds']` = 3600
 * `node['dse']['studio']['connection_management']['ide']['connection']['config_monitor_frequency_in_seconds']` = 120
 * `node['dse']['studio']['connection_management']['ide']['file']['service_port']` = 9091
 * `node['dse']['studio']['connection_management']['ide']['file']['contents_json_field']` = 'code'
 * `node['dse']['studio']['connection_management']['ide']['graph_schema_chache_idle_time_in_seconds']` = 600
 
## Usage

### dse_studio::default

```yaml
run_list:
      - recipe[java]
      - recipe[dse_studio::studio]
      - recipe[nginx]
      - recipe[dse_studio::reverse_proxy]
    attributes:
      java:
        install_flavor: 'oracle'
        jdk_version: 8
        oracle:
          accept_oracle_download_terms: true
      dse:
        studio:
          repo_user: ...
          repo_pass: ...
      nginx:
        default_site_enabled: false
```

### Setting up an Nginx Proxy

If you want SSL-encrypted connections, you'll need to front this with a reverse proxy. Here's an example using [nginx-proxy](https://github.com/3ofcoins/chef-cookbook-nginx-proxy/), taken from a packer definition file:

```json
{
  "type": "chef-solo",
  "install_command": "curl -L https://www.chef.io/chef/install.sh | {{if .Sudo}}sudo{{end}} bash -s -- -v {{user `chef-version`}}",
  "cookbook_paths": [ "cookbooks" ],
  "run_list": [
    "java",
    "nginx",
    "dse_studio"
  ],
  "json": {
    "java": {
      "jdk_version": "8",
      "install_flavor": "oracle",
      "oracle": {
        "accept_oracle_download_terms": true
      },
      "alternatives_priority": 20000
    },
    "dse": {
      "studio": {
        "repo_user": "...",
        "repo_pass": "..."
      }
    },
    "nginx": {
      "default_site_enabled": false
    },
    "nginx_proxy": {
      "proxies": {
        "localhost": {
          "url": "http://localhost:9091",
          "ssl_key_path": "/opt/ssl/cert.key",
          "ssl_certificate_path": "/opt/ssl/cert.crt"
        }
      }
    }
  }
}
```

Contributing
------------

The usual. Also as usual, highly welcome! 

 1. Fork the repository on Github
 2. Create a named feature branch (like `add_component_x`)
 3. Write your change
 4. Write tests for your change (if applicable)
 5. Run the tests, ensuring they all pass
 6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Thorsten Krüger
