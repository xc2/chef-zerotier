Ohai.plugin(:ZerotierInfo) do
  provides 'zerotier_info'

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

  def collect_info
    info = command('info')
    if info
      info = Mash.from_hash(info)
      info[:installed] = true
      info[:cli] = cli
      info[:node_id] = info[:address]
      info.delete(:clock)
    else
      info = Mash.from_hash({installed: false, cli: cli})
    end
    info
  end

  collect_data(:linux) do
    zerotier_info collect_info
  end
end
