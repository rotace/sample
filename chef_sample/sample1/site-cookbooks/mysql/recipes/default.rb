#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "mysql" do
  action:install
  package_name "mysql"
end

package "mysqld-server" do
  action:install
  package_name "mysql-server"
end

package "mysql-devel" do
  action:install
  package_name "mysql-devel"
end

template "my.cnf" do
  action:create
  notifies :restart, "service[mysqld]", :immediately
  group  "root"
  user   "root"
  mode   "644"
  path   "/etc/my.cnf"
  source "my.cnf.erb"
end

service "mysqld" do
  action [:enable, :start]
  service_name "mysqld"
end
