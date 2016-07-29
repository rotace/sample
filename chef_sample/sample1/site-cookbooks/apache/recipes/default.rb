#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "httpd" do
  action :install
  package_name "httpd"
end

package "httpd-devel" do
  action :install
  package_name "httpd-devel"
end

template "httpd.conf" do
  action :create
  notifies :restart, "service[httpd]", :immediately
  group  "root"
  user   "root"
  mode   "644"
  path   "/etc/httpd/conf/httpd.conf"
  source "httpd.conf.erb"
end

service "httpd" do
  action [:enable, :start]
  service_name "httpd"
end
