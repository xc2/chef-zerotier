provides :zerotier_network
property :network_id, String, name_property: true
property(:node_name, String, default: lazy { node['fqdn'] })
property :auth_token, String
# not used
property(:central_url, String, default: lazy { node['zerotier']['central_url'] })
property(:binary, String, default: lazy { node['zerotier']['binary'] })
property(:data_dir, String, default: lazy { node['zerotier']['data_dir'] })
property(:control_port, Integer, default: lazy { node['zerotier']['control_port'] })

action :join do
  r = new_resource
  network_id = r.network_id
  node_name = r.node_name
  auth_token = r.auth_token
  command = [r.binary, "-p#{r.control_port}", "-D#{r.data_dir}"]
  conf_file = "#{r.data_dir}/networks.d/#{network_id}.conf"

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
  r = new_resource
  network_id = r.network_id
  node_name = r.node_name
  auth_token = r.auth_token
  command = [r.binary, "-p#{r.control_port}", "-D#{r.data_dir}"]
  conf_file = "#{r.data_dir}/networks.d/#{network_id}.conf"

  unless auth_token.to_s.empty?
    command << "-T#{auth_token}"
  end

  command << "leave" << network_id

  execute "leave #{network_id}" do
    command command
    only_if { ::File.exist?(conf_file) }
  end
end
