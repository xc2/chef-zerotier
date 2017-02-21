#
# Cookbook:: chef-zerotier
# Recipe:: ohai_plugin
#
# Copyright:: 2017, ZeroTier, Inc., All Rights Reserved.

include_recipe 'chef-zerotier::install'

ohai_plugin 'zerotier_ohai'
