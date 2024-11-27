Ohai.plugin(:ZerotierInfo) do
  provides 'zerotier_info'

  collect_data(:linux) do
    zerotier_info Mash.new
    zerotier_info[:installed] = false
    if ChefZerotier::Helpers.binary_exists?(node)
      zerotier_info Mash.from_hash(ChefZerotier::Helpers.command(node, 'info'))
      zerotier_info[:installed] = true
      zerotier_info[:node_id] = zerotier_info[:address]
      zerotier_info.delete(:clock)
    else
      Ohai::Log.warn('Cannot find zerotier binary')
    end
  end
end
