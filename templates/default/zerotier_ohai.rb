
Ohai.plugin(:ZeroTier) do
  provides 'zerotier'

  def zerotier_command(subcommand)
    "<%= @zerotier_binary %> <% unless @zerotier_binary.end_with?('-cli') %>-q<% end %> #{subcommand} -p<%= @control_port %> -D<%= @data_dir %>"
  end

  def linux_get_networks
    networks = Mash.new
    cmd = zerotier_command('listnetworks')
    Ohai::Log.info(cmd)
    so = shell_out(cmd)
    first_line = true
    so.stdout.lines do |line|
      if first_line
        # skip the header line
        first_line = false
        next
      end

      data = line.strip.split(/\s+/)

      cur_network = Mash.new
      cur_network[:network_name] = data[3]
      cur_network[:mac] = data[4]
      cur_network[:status] = data[5]
      cur_network[:type] = data[6]
      cur_network[:interface] = data[7]
      cur_network[:addresses] = []

      data[8].split(',').each do |addr|
        cur_network[:addresses].push(addr)
      end

      networks[data[2]] = cur_network
    end
    networks
  end

  def linux_get_node_id
    node_id = ''

    if ::File.exist?('<%= @data_dir %>/identity.public')
      node_id = ::File.read('<%= @data_dir %>/identity.public')
      node_id = node_id[0..9]
      Ohai
    else
      Ohai::Log.warn("<%= @data_dir %>/identity.public' does not exist")
    end

    return node_id unless node_id.empty?
  end

  def get_version
    so = shell_out('<%= @zerotier_binary %> -v 2>&1')
    version = so.stdout.strip
    return version unless version.empty?
  end

  collect_data(:linux) do
    if ::File.exist?('<%= @zerotier_binary %>')
      zerotier Mash.new
      zerotier[:version]    = get_version
      zerotier[:node_id]    = linux_get_node_id
      zerotier[:networks]   = linux_get_networks
    else
      Ohai::Log.warn('Cannot find zerotier binary')
    end
  end
end
