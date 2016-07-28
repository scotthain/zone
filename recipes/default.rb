#
# Cookbook Name:: zone
# Recipe:: default
#
# Copyright (c) 2016 Scott Hain <shain@chef.io>, All Rights Reserved.

zone 'zone-is-amazing-11' do
  zone_ip '192.168.1.150'
  hostname 'mything.chef.co'
  global_network_adapter 'net0'
  #  config_attributes [ 'add addr', 'do_something', 'do something else', 'end' ]
  action :create
end
