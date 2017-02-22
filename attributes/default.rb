
# Not set by default.
# default['zerotier']['version']
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
