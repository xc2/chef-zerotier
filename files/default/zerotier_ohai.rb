
Ohai.plugin(:ZeroTier) do
    provides 'zerotier'

    def linux_get_interfaces
        interfaces = Mash.new

        interfaces
    end

    def linux_get_node_id
        node_id = ''

        if ::File.exists?('/var/lib/zerotier-one/identity.public')
            node_id = ::File.read('/var/lib/zerotier-one/identity.public')
            node_id = node_id[0..9]
            Ohai
        else
            Ohai::Log.warn("'/var/lib/zerotier-one/identity.public' does not exist")
        end

        return node_id unless node_id.empty?
    end

    def get_version
        so = shell_out("/usr/sbin/zerotier-cli -v 2>&1")
        version = so.stdout.strip
        return version unless version.empty?
    end

    def find_zerotier
        so = shell_out("/bin/bash -c 'command -v zerotier-cli'")
        zerotier_bin = so.stdout.strip
        return zerotier_bin unless zerotier_bin.empty?
    end

    collect_data(:linux) do
        if find_zerotier
            zerotier Mash.new
            zerotier[:version] = get_version
            zerotier[:node_id] = linux_get_node_id
        else
            Ohai::Log.warn("Cannot find zerotier-cli")
        end
    end
end