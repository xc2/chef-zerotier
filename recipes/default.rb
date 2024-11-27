#
# Cookbook:: zerotier
# Recipe:: default
#
# Copyright:: 2017, ZeroTier, Inc., All Rights Reserved.
include_recipe 'zerotier::install'
include_recipe 'zerotier::join_networks'
