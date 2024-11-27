ohai "zerotier info" do
  plugin "zerotier_info"
  action :reload
end

ohai "zerotier networks" do
  plugin "zerotier_networks"
  action :reload
end
