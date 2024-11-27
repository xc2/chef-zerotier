property :network_id, String, name_property: true
property :auth_token, String

default_action :join

def do_action(r, act = :join)
  ohai "zerotier info" do
    plugin "zerotier_info"
    action :reload
  end

  ohai "zerotier networks" do
    plugin "zerotier_networks"
    action :reload
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
    command ChefZerotier::Helpers.generate_command(command)
    if should_absent
      only_if node['zerotier_networks'][r.network_id]
    else
      not_if node['zerotier_networks'][r.network_id]
    end
    notifies :reload, "ohai[zerotier networks]", :delayed
  end
end

action :join do
  do_action(new_resource, :join)
end

action :leave do
  do_action(new_resource, :leave)
end
