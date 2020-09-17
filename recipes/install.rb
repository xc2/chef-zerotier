#
# Cookbook:: zerotier
# Recipe:: install
#
# Copyright:: 2017, ZeroTier, Inc., All Rights Reserved.

case node['platform_family']
when 'debian'
  apt_repository 'zerotier' do
    uri "http://download.zerotier.com/debian/#{node['lsb']['codename']}"
    components ['main']
    key 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg'
    trusted true
  end
when 'rhel', 'amazon', 'fedora'
  base_url = case node['platform']
             when 'amazon'
               if node['platform_version'].to_i >= 2010 # legacy Amazon Linux 201x releases
                 'https://download.zerotier.com/redhat/amzn1/'
               else
                 'https://download.zerotier.com/redhat/el/7'
               end
             when 'fedora'
               'https://download.zerotier.com/redhat/fc/$releasever'
             else
               'https://download.zerotier.com/redhat/el/$releasever'
             end

  yum_repository 'zerotier' do
    description 'ZeroTier Repo'
    baseurl base_url
    gpgkey 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg'
  end
else
  Chef::Log.fatal("Platform Family '#{node['platform_family']}' is not yet supported by this recipe")
end

package 'zerotier-one' do
  if node['zerotier']['version']
    version node['zerotier']['install_version']
  end
end

service 'zerotier-one' do
  action [:enable, :start]
  supports status: true, restart: true, start: true, stop: true
end

include_recipe 'zerotier::ohai_plugin'