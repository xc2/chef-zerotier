
# Not set by default.
# default['zerotier']['install_version']
#

default['zerotier']['central_url'] = 'https://my.zerotier.com'

# Public networks to autojoin.
default['zerotier']['public_autojoin'] = []

# Private networks to autojoin.  Requires ZeroTier Central API api key.
#
# Packed in the following format:
#
#    [{
#       :network_id => "",
#       :auth_token => "key",
#       :central_url => "http://my.zerotier.com" // optional.  Defaults to https://my.zerotier.com
#     },
#     ...
#    ]
#
default['zerotier']['private_autojoin'] = []

# Binary path to ZeroTier.  Shouldn't be changed unless you know what you're doing
default['zerotier']['binary'] = '/usr/sbin/zerotier-cli'
default['zerotier']['data_dir'] = '/var/lib/zerotier-one'
default['zerotier']['control_port'] = 9993
