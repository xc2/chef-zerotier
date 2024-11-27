require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut

module ChefZerotier
  module Helpers
    @@binary = nil

    def self.binary(node)
      if @@binary.nil?
        if ::File.exist?(node['zerotier']['binary'])
          @@binary = {:type => 'cli', :path => node['zerotier']['binary']}
        elsif ::File.exist?(node['zerotier']['service_binary'])
          @@binary = {:type => 'service', :path => node['zerotier']['service_binary']}
        end
      end
      @@binary
    end

    def self.binary_exists?(node)
      !binary(node).nil?
    end
    def self.generate_command(node, subcommand)
      if binary(node).nil?
        raise "Cannot find zerotier binary"
      end
      if subcommand.is_a?(Array)
        subcommand = subcommand.join(' ')
      end
      if @@binary[:type] == 'cli'
        "#{@@binary[:path]} -p#{node['zerotier']['control_port']} '-D#{node['zerotier']['data_dir']}' #{subcommand}"
      else
        "#{@@binary[:path]} -q #{subcommand} -p#{node['zerotier']['control_port']} '-D#{node['zerotier']['data_dir']}"
      end
    end

    def self.command(node, subcommand, ignore_failure = false, defaults = {})
      so = shell_out("-j #{generate_command(node, subcommand)}")
      if so.exitstatus == 0
        Chef::JSONCompat.from_json(so.stdout, symbolize_keys: true)
      elsif ignore_failure
        defaults
      else
        raise so
      end
    end
  end
end
