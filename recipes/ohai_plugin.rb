#
# Cookbook:: zerotier
# Recipe:: ohai_plugin
#
# Copyright:: 2017, ZeroTier, Inc., All Rights Reserved.

ohai_plugin 'zerotier_ohai' do
    compile_time false
    resource :template
    variables ({
        :zerotier_binary => node['zerotier']['binary'],
        :control_port => node['zerotier']['control_port'],
        :data_dir => node['zerotier']['data_dir']
    })
end
