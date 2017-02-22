actions :join, :leave
default_action :join

attribute :network_id, :kind_of => String, :name_attribute => true, :required => true
attribute :node_name, :kind_of => String, :required => false
attribute :auth_token, :kind_of => String, :required => false
attribute :central_url, :kind_of => String, :default => "https://my.zerotier.com"
