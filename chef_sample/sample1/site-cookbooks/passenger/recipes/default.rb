#
# Cookbook Name:: passenger
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# set apache config for passenger

template "passenger.conf" do
  action:create
  notifies :restart, "service[httpd]", :immediately
  group  "root"
  user   "root"
  mode   "644"
  path   "/etc/httpd/conf.d/passenger.conf"
  source "passenger.conf.erb"
end

service "httpd" do
  action [:enable, :start]
  service_name "httpd"
end
