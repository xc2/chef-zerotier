#
# Cookbook:: zerotier
# Recipe:: join_networks
#
# Copyright:: 2017, ZeroTier, Inc., All Rights Reserved.

include_recipe 'zerotier::ohai_plugin'

node['zerotier']['managed_networks'].each do |name, nw|
  network = {
    'network_id' => name,
    'disabled' => false,
  }
  if nw.nil?
    nw = true
  end
  if nw == true || nw == false
    network['disabled'] = !nw
  end
  if nw.is_a?(String)
    network['network_id'] = nw
  end
  if nw.is_a?(Hash)
    network = network.merge(nw)
  end

  zerotier_network name do
    network_id network['network_id']
    action network['disabled'] ? :leave : :join
    node_name network['node_name']
    auth_token network['auth_token']
  end
end
