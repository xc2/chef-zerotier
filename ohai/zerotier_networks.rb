Ohai.plugin(:ZerotierNetworks) do
  provides 'zerotier_networks'

  def cli
    @cli ||= which('zerotier-cli')
    @cli
  end
  def command(subcommand)
    unless cli
      Ohai::Log.debug("zerotier-cli not found in PATH")
      return nil
    end
    so = shell_out("#{cli} #{subcommand} -j")
    if so.exitstatus == 0
      parse_json(so.stdout)
    else
      Ohai::Log.debug(so.stderr)
      nil
    end
  end

  collect_data(:linux) do
    zerotier_networks Mash.new
    nws = command('listnetworks')

    if nws.is_a?(Array)
      nws.each do |nw|
        nw = Mash.from_hash(nw)
        zerotier_networks[nw[:id].to_sym] = nw
      end
    end
  end
end
