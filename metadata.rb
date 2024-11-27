name 'zerotier'
maintainer 'Grant Limberg'
maintainer_email 'grant.limberg@zerotier.com'
license 'GPL-3.0'
description 'Installs/Configures ZeroTier'
version '1.0.7'
issues_url 'https://github.com/zerotier/chef-zerotier/issues'
source_url 'https://github.com/zerotier/chef-zerotier'

%w(redhat centos amazon scientific ubuntu debian).each do |os|
  supports os
end

chef_version '>= 16.0'
