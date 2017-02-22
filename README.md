ZeroTier Cookbook
==================

This is a [Chef](https://www.chef.io/) cookbook to manage [ZeroTier](https://www.zerotier.com) networks on your Chef nodes.

Supported Platforms
---------------------
* Debian
* Ubuntu
* CentOS
* RHEL
* Amazon

Recipes
---------------------
`zerotier::default`

Default recipe.  Calls `zerotier::install`

`zerotier::install` 

Install's ZeroTier One on your system via the native package management system.

`zerotier::ohai_plugin` 

Installs the Ohai plugin for ZeroTier.  This is required by the provided LWRP `zerotier_network`.

`zerotier::join_networks`

Shortcut to automatically join networks stored in attributes (See example in the Attributes section below)

Attributes
---------------------
`node['zerotier']['version']` 

Version of ZeroTier to install.  Empty by default and defaults to the latest version available.

`node['zerotier']['central_url']`

URL to the instance of the ZeroTier Central controller. Defaults to https://my.zerotier.com.  Will be useful in the future when Central is distributable to our enterprise customers.

`node['zerotier']['public_autojoin']`

List of *public* networks to automatically join when using the `zerotier::join_networks` recipe.  These networks do not require any interaction with the network controller.

`node['zerotier']['private_autojoin']`

List of *private* networks to automatically join when using the `zerotier::join_networks` recipe.  Joining a private network requires an API Access Token generated at https://my.zerotier.com.  Each member of the list is a hash as follows:

```
{
	:network_id => "your_network_id",
    :auth_token => "your_auth_token",  # API access token generated at https://my.zerotier.com
    :central_url => "URL_to_central_instance" # Not required.  Defaults to https://my.zerotier.com
}
```

LWRP
---------------------
The ZeroTier recpie provides the `zerotier_network` lwrp

Attributes:

- network_id - Network ID to join. defaults to the name attribute.
- node_name - Name of the node to put in https://my.zerotier.com (only applicable when joining a private network)
- auth_token - API access token generated in your account at https://my.zerotier.com. Required if you wish to automatically authorize the node to join the network.
- central_url - URL to the instance of ZeroTier Central.  Defaults to https://my.zerotier.com.
