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

class Chef
  class Resource
    class Zone < Chef::Resource::LWRPBase
      resource_name :zone

      actions :create, :delete, :reconfigure
      default_action :create

      attribute :zone_name, kind_of: String, name_attribute: true
      attribute :hostname, kind_of: String, required: true
      attribute :zone_base_dir, kind_of: String, default: '/zones'
      attribute :zone_ip, kind_of: String, required: true
      attribute :network_device, kind_of: String
      attribute :password, kind_of: String, default: "changeme"
      attribute :global_network_adapter, kind_of: String
      attribute :config_attributes, kind_of: Array
    end
  end
end
