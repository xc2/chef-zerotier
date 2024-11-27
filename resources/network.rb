property :network_id, String, name_property: true
property :auth_token, String

default_action :join

action_class do
  def do_action(r, act = :join)
    ohai "zerotier networks" do
      plugin "zerotier_networks"
      action :nothing
    end

    network_id = r.network_id
    auth_token = r.auth_token

    should_absent = act == :leave
    work = should_absent ? "leave" : "join"

    command = []
    unless auth_token.to_s.empty?
      command << "-T#{auth_token}"
    end
    command << work << network_id

    execute "#{work} #{network_id}" do
      command ChefZerotier::Helpers.generate_command(node, command)
      if should_absent
        only_if node['zerotier_networks'][r.network_id]
      else
        not_if node['zerotier_networks'][r.network_id]
      end
      notifies :reload, "ohai[zerotier networks]", :delayed
    end
  end
end

action :join do
  do_action(new_resource, :join)
end

action :leave do
  do_action(new_resource, :leave)
end
