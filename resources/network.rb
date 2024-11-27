require 'uri'

property :network_id, String, name_property: true
property :node_name, String, required: false
property :auth_token, String, required: false
property :central_url, String, default: 'https://my.zerotier.com'

action :join do
  if ::File.exist?(format('/var/lib/zerotier-one/networks.d/%s.conf', network_id))
    Chef::Log.info(format('Network %s already joined. Skipping.', network_id))
  else
    converge_by(format('Joining network %s', network_id)) do
      join = shell_out(format('/usr/sbin/zerotier-cli join %s', network_id))
      raise format('Error joining network %s', network_id) if join.error?

      if auth_token
        url = URI.parse(format('%s/api/network/%s/member/%s/', central_url, network_id, node['zerotier']['node_id']))
        node_name = node_name.nil? ? node['fqdn'] : node_name

        netinfo = {
            networkId: network_id,
            nodeId: node['zerotier']['node_id'],
            name: node_name,
            config: {
                nwid: network_id,
                authorized: true,
            },
        }

        response = Net::HTTP.start(url.host, url.port, use_ssl: url.scheme == 'https') do |http|
          post = Net::HTTP::Post.new(url, 'Content-Type' => 'application/json')
          post.add_field('Authorization', format('Bearer %s', auth_token))
          post.body = netinfo.to_json
          http.request(post)
        end

        case response
        when Net::HTTPSuccess
        # do nothing
        else
          shell_out(format('/usr/sbin/zerotier-cli leave %s', network_id))
          error = JSON.parse(response.body)
          raise format('Error %s authorizing network: %s: %s', response.code, error['type'], error['message'])
        end
      end
    end
  end
end

action :leave do
  if ::File.exist?(format('/var/lib/zerotier-one/networks.d/%s.conf', network_id))
    converge_by(format('Leaving network %s', network_id)) do
      leave = shell_out(format('/usr/sbin/zerotier-cli leave %s', network_id))
      raise format('Error leaving network %s', network_id) if leave.error?
    end
  else
    Chef::Log.warn(format('Network %s is not joined. Skipping', network_id))
  end
end
