#
# Cookbook Name:: scpr-riakcs
# Recipe:: default
#
# Copyright (c) 2014 Southern California Public Radio, All Rights Reserved.

# -- Install Riak CS -- #

include_recipe "riak::package"

['bitcask','leveldb'].each do |b|
  directory "#{node.riak.data_dir}/#{b}" do
    action :create
    owner "riak"
    recursive true
  end
end

include_recipe "riak-cs::package"
include_recipe "riak"
include_recipe "riak-cs"

# This installs on all nodes, even though we only want nodes using one
# stanchion at a time
include_recipe "riak-cs::stanchion"

# -- Install SSL Cert -- #

['cacert','cert','key'].each do |f|
  cookbook_file "/etc/ssl/riak-#{f}.pem" do
    action  :create
    source  "#{f}.pem"
    owner   "riak"
    mode    0644
  end
end

# -- register with Consul -- #

consul_service_def node.scpr_riakcs.consul_service do
  action    :create
  tags      ["riakcs","stanchion"]
  notifies  :reload, "service[consul]"
end
