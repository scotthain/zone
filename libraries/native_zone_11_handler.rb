#
# Author:: Scott Hain <shain@chef.io>
# Copyright (c) 2016, Chef Software, Inc. <legal@chef.io>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'digest/sha2'

module Zone
  module NativeZone11Handler
    def handle_create
      template "#{Chef::Config[:file_cache_path]}/#{new_resource.zone_name}.xml" do
        source 'zone_profile.xml.erb'
        owner 'root'
        group 'root'
        mode '0644'
        cookbook 'zone'
        variables(
          hostname: new_resource.hostname,
          password_hash: hash_it(new_resource.password)
        )
        action :create
      end

      template "#{Chef::Config[:file_cache_path]}/#{new_resource.zone_name}.zonecfg" do
        source 'zonecfg.erb'
        owner 'root'
        group 'root'
        mode '0644'
        cookbook 'zone'
        variables(
          zone_base_dir: new_resource.zone_base_dir,
          zone_name: new_resource.zone_name,
          zone_ip: new_resource.zone_ip,
          network_device: new_resource.global_network_adapter, # || first_network_device,
          config_attributes: new_resource.config_attributes
        )
        action :create
      end

      if zone_exists? (new_resource.zone_name)
        Chef::Log.warn "ZONE EXISTS ALREADY!"
      else
        ruby_block 'configure_zone' do
          block do
            Chef::Log.warn("Defining zone #{new_resource.zone_name}")
            zonecfg_exec = Mixlib::ShellOut.new("zonecfg -z '#{new_resource.zone_name}' -f #{Chef::Config[:file_cache_path]}/#{new_resource.zone_name}.zonecfg").run_command
            Chef::Log.warn zonecfg_exec.stdout
            Chef::Log.warn zonecfg_exec.stderr
            zonecfg_exec.error!
          end
          action :run
        end

        ruby_block 'install_zone' do
          block do
            Chef::Log.warn("Installing zone #{new_resource.zone_name}")
            zoneadm_cfg = Mixlib::ShellOut.new("zoneadm -z #{new_resource.zone_name} install -c #{Chef::Config[:file_cache_path]}/#{new_resource.zone_name}.xml").run_command
            Chef::Log.warn zoneadm_cfg.stdout
            Chef::Log.warn zoneadm_cfg.stderr
            zoneadm_cfg.error!
          end
          action :run
        end
      end
    end

    def handle_delete

    end

    def handle_reconfigure

    end

    def hash_it(password)
#      salt = rand(36**6).to_s(36)
      salt = rand(36**8).to_s(36)
      password.crypt("$6$" + salt)
    end

    #
    # run 'zoneadm -z zone_name list -p' with the intention of finding out if the
    # zone exists
    #
    def zone_exists?(zone_name)
      ruby_block 'run_command' do
        block do
          output = Mixlib::ShellOut.new("zoneadm -z #{zone_name} list -p").run_command
        end
        action :run
      end
      # nope wrong wrong wrong
      # if output.stdout.split(':')[1].eql? zone_name
      #   true
      # else
      #   false
      # end
    end

    # def first_network_device
    #   puts node['network']['interfaces'].to_s
    # end

  end
end
