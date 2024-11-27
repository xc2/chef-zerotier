provides :zerotier_network
property :network_id, String, name_property: true
property :node_name, String, required: false
property :auth_token, String, required: false
# not used
property :central_url, String, default: 'https://my.zerotier.com'

action :join do
  network_id = new_resource.network_id
  node_name = (new_resource.node_name or node['fqdn'])
  auth_token = new_resource.auth_token
  command = [node['zerotier']['binary']]
  conf_file = "#{node['zerotier']['data-dir']}/networks.d/#{network_id}.conf"

  unless auth_token.to_s.empty?
    command << "-T#{auth_token}"
  end

  command << "join" << network_id

  execute "join #{network_id}" do
    command command
    not_if { ::File.exist?(conf_file) }
  end
end

action :leave do
  network_id = new_resource.network_id
  node_name = (new_resource.node_name or node['fqdn'])
  auth_token = new_resource.auth_token
  command = [node['zerotier']['binary']]
  conf_file = "#{node['zerotier']['data-dir']}/networks.d/#{network_id}.conf"

  unless auth_token.to_s.empty?
    command << "-T#{auth_token}"
  end

  command << "leave" << network_id

  execute "leave #{network_id}" do
    command command
    only_if { ::File.exist?(conf_file) }
  end
end
