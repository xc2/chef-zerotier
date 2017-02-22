require 'chef/log'
require "net/http"
require "net/https"
require "uri"
require "json"
require 'mixlib/shellout'

use_inline_resources

def load_current_resource
    @current_resource = Chef::Resource::ZerotierNetwork.new(new_resource.network_id)
    @current_resource.node_name(new_resource.node_name)
    @current_resource.auth_token(new_resource.auth_token)
    @current_resource.central_url(new_resource.central_url)
    @current_resource
end

def whyrun_supported?
    true
end

action :join do
    if ::File.exists?("/var/lib/zerotier-one/networks.d/#{new_resource.network_id}.conf")
        Chef::Log.info("Network #{new_resource.network_id} already joined. Skipping.")
    else
        converge_by("Joining Network #{new_resource.network_id}") do
            join = Mixlib::ShellOut.new("/usr/sbin/zerotier-cli join #{new_resource.network_id}")
            join.run_command
            raise "Error joining network #{new_resource.network_id}" if join.error?

            if new_resource.auth_token
                url = URI.parse("#{new_resource.central_url}/api/network/#{new_resource.network_id}/member/#{node['zerotier']['node_id']}/")
            
                netinfo = {
                    :networkId => new_resource.network_id,
                    :nodeId => node['zerotier']['node_id'],
                    :name => new_resource.node_name,
                    :config => {
                        :nwid => new_resource.network_id,
                        :authorized => true
                    }
                }

                response = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') do |http|
                    post = Net::HTTP::Post.new(url, 'Content-Type' => 'application/json')
                    post.add_field('Authorization', "Bearer #{new_resource.auth_token}")
                    post.body = netinfo.to_json
                    http.request(post)
                end

                case response
                when Net::HTTPSuccess
                    # do nothing
                else
                    leave = Mixlib::ShellOut.new("/usr/sbin/zerotier-cli leave #{new_resource.network_id}")
                    leave.run_command
                    error = JSON.parse(response.body)
                    raise "Error #{response.code} authorizing network: #{error['type']}: #{error['message']}"
                end
            end

            new_resource.updated_by_last_action(true)
        end
    end
end

action :leave do
    if ::File.exists?("/var/lib/zerotier-one/networks.d/#{new_resource.network_id}.conf")
        converge_by("Leaving network #{new_resource.network_id}") do
            leave = Mixlib::ShellOut.new("/usr/sbin/zerotier-cli leave #{new_resource.network_id}")
            leave.run_command
            raise "Error leaving network #{new_resource.network_id}" if leave.error?
            new_resource.updated_by_last_action(true)
        end
    else
        Chef::Log.warn("Network #{new_resource.network_id} is not joined.  Skipping.")
    end
end
