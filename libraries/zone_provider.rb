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

require_relative './helpers'
require_relative './native_zone_10_handler'
require_relative './native_zone_11_handler'

class Chef
  class Provider
    class Zone < Chef::Provider::LWRPBase # ~FC058
      provides :zone
      use_inline_resources

      include ZoneCookbook::Helpers

      def whyrun_supported?
        true
      end

      def initialize(name, run_context = nil)
        super(name, run_context)
        case node['platform_version']
        when '5.10'
          Chef::Log.warn "I'm 10"
          extend ::Zone::NativeZone10Handler
        when '5.11'
          Chef::Log.warn "I'm 11"
          extend ::Zone::NativeZone11Handler
        else
          Chef::Log.warn "Zones are not supported on Solaris version #{node['platform_version']} - no action taken"
        end
      end

      action :create do

        handle_create
      end

      action :delete do

        handle_delete
      end

      action :reconfigure do

        handle_reconfigure
      end
    end
  end
end
