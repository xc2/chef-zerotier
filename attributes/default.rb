


default['zt']['central_url'] = 'https://my.zerotier.com'
default['zt']['api_url'] = URI.join(node['zt']['central_url'], '/api/')

# Public networks to autojoin.  Does not require api_key
default['zt']['public_autojoin'] = []

# Private networks to autojoin.  Requires ZeroTier Central API api key.
#
# Packed in the following format:
#
#    [{:network_id => "", :api_key => "key"},...]
#
default['zt']['private_autojoin'] = []
