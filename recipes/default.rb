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

# -- register with Consul -- #

consul_service_def node.scpr_riakcs.consul_service do
  action    :create
  tags      ["riakcs"]
  port      node['riak_cs']['config']['riak_cs']['cs_port']

  check(
    interval: "5s",
    script:   "riak ping && riak-cs ping"
  )

  notifies  :reload, "service[consul]"
end

consul_service_def node.scpr_riakcs.consul_service do
  action    :create
  id        "#{node.scpr_riakcs.consul_service}-stanchion"
  tags      ["stanchion"]
  port      node['stanchion']['config']['stanchion']['stanchion_port']

  check(
    interval: "5s",
    script:   "riak ping && stanchion ping"
  )

  notifies  :reload, "service[consul]"
end