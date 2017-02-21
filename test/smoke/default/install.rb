# # encoding: utf-8

# Inspec test for recipe .::install

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

def node
  JSON.parse(IO.read('/tmp/kitchen/chef_node.json'))
end



