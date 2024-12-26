#
# Cookbook:: zerotier
# Recipe:: join_networks
#
# Copyright:: 2017, ZeroTier, Inc., All Rights Reserved.

node['zerotier']['networks'].each do |name, nw|
  network = {
    'network_id' => name,
    'disabled' => false,
  }
  if nw.nil?
    nw = true
  end
  if nw.is_a?(TrueClass) || nw.is_a?(FalseClass)
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
    auth_token network['auth_token']
  end
end
