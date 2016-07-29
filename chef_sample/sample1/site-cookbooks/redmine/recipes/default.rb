#
# Cookbook Name:: redmine
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


# set redmine config

template "database.yml" do
  action:create
  group  "apache"
  user   "apache"
  mode   "644"
  path   "#{node['redmine']['install-dir']}/config/database.yml"
  source "database.yml.erb"
end

template "configuration.yml" do
  action:create
  group  "apache"
  user   "apache"
  mode   "644"
  path   "#{node['redmine']['install-dir']}/config/configuration.yml"
  source "configuration.yml.erb"
end




