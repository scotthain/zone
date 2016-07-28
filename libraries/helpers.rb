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

module ZoneCookbook
  module Helpers

    #
    # Ensures mixlib-shellout gem is installed and loaded.
    #
    def ensure_mixlib_shellout_gem_installed!
      node.run_state[:mixlib_shellout_gem_installed] ||= begin # ~FC001
        install_gem_from_rubygems('mixlib-shellout', '2.2.6')

        require 'mixlib/shellout'
        true
      end
    end

    #
    # Helper method to install a gem from rubygems at compile time.
    #
    def install_gem_from_rubygems(gem_name, gem_version)
      Chef::Log.warn("Installing #{gem_name} v#{gem_version} from Rubygems.org")
      chefgem = Chef::Resource::ChefGem.new(gem_name, run_context)
      chefgem.version(gem_version)
      chefgem.run_action(:install)
    end

    # def run_command(command)
    #
    # end
  end
end
