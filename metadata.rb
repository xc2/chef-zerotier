name 'zerotier'
maintainer 'Grant Limberg'
maintainer_email 'grant.limberg@zerotier.com'
license 'GPL-3.0'
description 'Installs/Configures ZeroTier'
version '1.0.7'
issues_url 'https://github.com/zerotier/chef-zerotier/issues' if respond_to?(:issues_url)
source_url 'https://github.com/zerotier/chef-zerotier' if respond_to?(:source_url)

%w(redhat centos amazon ubuntu debian).each do |os|
    supports os
end

depends 'ohai'
