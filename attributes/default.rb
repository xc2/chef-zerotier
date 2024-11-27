
# Not set by default.
# default['zerotier']['install_version']
#

default['zerotier']['central_url'] = 'https://my.zerotier.com'


#  Networks to autojoin
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
default['zerotier']['networks'] = {}

# Binary path to ZeroTier.  Shouldn't be changed unless you know what you're doing
default['zerotier']['binary'] = '/usr/sbin/zerotier-cli'
default['zerotier']['service_binary'] = '/usr/sbin/zerotier-one'
default['zerotier']['service_name'] = 'zerotier-one'
default['zerotier']['data_dir'] = '/var/lib/zerotier-one'
default['zerotier']['control_port'] = 9993
