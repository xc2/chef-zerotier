Ohai.plugin(:ZerotierNetworks) do
  provides 'zerotier_networks'

  collect_data(:linux) do
    zerotier_networks Mash.new
    if ChefZerotier::Helpers.binary_exists?(node)
      so = ChefZerotier::Helpers.command(node, 'listnetworks')

      if so.is_a?(Array)
        so.each do |network|
          zerotier_networks[network[:id].to_sym] = Mash.from_hash(network)
        end
      else
        Ohai::Log.warn('Network response should be an array.')
      end
    end
  end
end
