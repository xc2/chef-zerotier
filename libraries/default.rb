require 'chef/mixin/shell_out'
require 'shellwords'
include Chef::Mixin::ShellOut

module ChefZerotier
  class Zerotier
    def initialize(data_dir:nil, binary:nil, service_binary:nil, control_port:nil)
      @binary = (binary or which("zerotier-cli") or nil)
      @service_binary = (service_binary or which("zerotier-one") or nil)
      @data_dir = data_dir
      @control_port = control_port
      @@binary = nil
    end

    def binary
      if @@binary.nil?
        if !@binary.nil? && ::File.exist?(@binary)
          @@binary = {:type => 'cli', :path => @binary}
        elsif !@service_binary && ::File.exist?(@service_binary)
          @@binary = {:type => 'service', :path => @service_binary}
        end
      end
      @@binary
    end

    def binary?
      !self.binary.nil?
    end

    def generate_command(subcommand)
      b = binary
      cmd = []
      if b.nil?
        cmd << @binary
      elsif b[:type] == 'cli'
        cmd << b[:path]
      elsif b[:type] == 'service'
        cmd << b[:path] << "-q"
      end

      if subcommand.is_a?(String)
        cmd += subcommand.shellsplit
      elsif subcommand.is_a?(Array)
        cmd += subcommand
      end
      unless @control_port.nil?
        cmd << "-p#{@control_port}"
      end
      unless @data_dir.nil?
        cmd << "-D#{@data_dir}"
      end

      cmd.shelljoin
    end

    def network_exists?(network_id)
      ::File.exist?("#{@data_dir}/networks.d/#{network_id}.conf")
    end

    def command(subcommand, ignore_failure: false)
      so = shell_out("#{generate_command(subcommand)} -j")
      if so.exitstatus == 0
        Chef::JSONCompat.from_json(so.stdout, symbolize_keys: true)
      elsif ignore_failure
        nil
      else
        raise so
      end
    end
  end
end
