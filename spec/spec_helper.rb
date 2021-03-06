#
# Cookbook Name:: zone
# Spec:: default
#
# Copyright (c) 2016 Scott Hain <shain@chef.io>, All Rights Reserved.

require 'chefspec'
require 'chefspec/policyfile'

require_relative '../libraries/zone_provider'

RSpec.configure do |config|
  config.color = true
  config.formatter = 'doc'
  config.log_level = :error

  config.before(:each) do
    # artifact_info = instance_double('artifact info',
    #   url: 'http://packages.chef.io',
    #   sha256: 'f0e4c2f76c58916ec258f246851bea091d14d4247a2fc3e18694461b1816e13b')
    # installer = instance_double('installer', artifact_info: artifact_info)
    allow_any_instance_of(Chef::Provider::Zone).to receive(:installer).and_return(installer)
  end
end

at_exit { ChefSpec::Coverage.report! }
