#
# Cookbook:: chef-zerotier
# Recipe:: default
#
# Copyright:: 2017, ZeroTier, Inc., All Rights Reserved.

include_recipe 'chef-zerotier::install'

include_recipe 'chef-zerotier::ohai_plugin'
