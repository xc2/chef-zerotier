#
# Cookbook:: zerotier
# Recipe:: join_networks
#
# Copyright:: 2017, ZeroTier, Inc., All Rights Reserved.

include_recipe 'zerotier::ohai_plugin'

node['zerotier']['public_autojoin'].each do |nwid|
    zerotier_network nwid do
        action :join
    end
end

node['zerotier']['private_autojoin'].each do |network|
    zerotier_network network['network_id'] do
        only_if { network.key?("auth_token") }
        action :join
        auth_token network['auth_token']
        central_url network.key?("central_url") ? network[:central_url] : "https://my.zerotier.com"
        node_name node['fqdn']
    end
end