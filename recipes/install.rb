#
# Cookbook:: zerotier
# Recipe:: install
#
# Copyright:: 2017, ZeroTier, Inc., All Rights Reserved.

case node['platform']
when 'debian', 'ubuntu'
    apt_repository 'zerotier' do
        uri "http://download.zerotier.com/debian/#{node['lsb']['codename']}"
        components ['main']
        key 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg'
        trusted true
    end
when 'rhel', 'centos'
    yum_repository 'zerotier' do
        description "ZeroTier Repo"
        baseurl 'https://download.zerotier.com/redhat/el/$releasever'
        gpgkey 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg'
    end
when 'amazon'
    yum_repository 'zerotier' do
        description 'ZeroTier Repo'
        baseurl 'https://download.zerotier.com/redhat/amzn1/'
        gpgkey 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg'
    end
when 'fedora'
    yum_repository 'zerotier' do
        description 'ZeroTier Repo'
        baseurl 'https://download.zerotier.com/redhat/fc/22'
        gpgkey 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg'
    end
else
    Chef::Log.fatal("Platform '#{node['platform']}' is not yet supported by this recipe")
end

package 'zerotier-one' do
    if node['zerotier']['version']
        version node['zerotier']['install_version']
    end
end

service 'zerotier-one' do
    action [:enable, :start]
    supports :status => true, :restart => true, :start => true,:stop => true
end

include_recipe 'zerotier::ohai_plugin'