
default.scpr_riakcs.consul_service  = "s3"
default.scpr_riakcs.admin_key       = "INVALID"
default.scpr_riakcs.admin_secret    = "INVALID"
default.scpr_riakcs.root_host       = "s3.i.scprdev.org"

default.scpr_riakcs.anon_create     = true
default.scpr_riakcs.admin_auth      = false

default.scpr_riakcs.stanchion_ip    = node.ipaddress
default.scpr_riakcs.ip              = node.ipaddress

default.scpr_riakcs.data_dir        = "/data/riak"

#----------

include_attribute 'riak-cs'

default.riak_cs.package.version.major       = "1"
default.riak_cs.package.version.minor       = "5"
default.riak_cs.package.version.incremental = "2"
default.riak_cs.package.version.build       = "1"

default['riak_cs']['args']['-name'] = "riak-cs@#{node.name}.node.consul"

default['riak_cs']['config']['riak_cs']['stanchion_ip'] = node.scpr_riakcs.stanchion_ip.to_erl_string

default['riak_cs']['config']['riak_cs']['cs_root_host']                 = node.scpr_riakcs.root_host.to_erl_string
default['riak_cs_control']['config']['riak_cs_control']['cs_hostname']  = node.scpr_riakcs.root_host.to_erl_string

default['riak_cs']['config']['riak_cs']['cs_port']                  = 8080
default['riak_cs']['config']['riak_cs']['cs_ip']                    = "0.0.0.0".to_erl_string
default['riak_cs']['config']['riak_cs']['anonymous_user_creation']  = node.scpr_riakcs.anon_create
default['riak_cs']['config']['riak_cs']['admin_auth_enabled']       = node.scpr_riakcs.admin_auth
default['riak_cs']['config']['riak_cs']['riak_ip']                  = node.scpr_riakcs.ip.to_erl_string

default['riak_cs_control']['config']['riak_cs_control']['cs_proxy_host']  = node.scpr_riakcs.root_host.to_erl_string
default['riak_cs_control']['config']['riak_cs_control']['cs_proxy_port']  = 80
default['riak_cs_control']['config']['riak_cs_control']['cs_port']        = 80

default['riak_cs']['config']['riak_cs']['admin_key']    = node.scpr_riakcs.admin_key.to_erl_string
default['riak_cs']['config']['riak_cs']['admin_secret'] = node.scpr_riakcs.admin_secret.to_erl_string

default['riak_cs_control']['config']['riak_cs_control']['cs_admin_key']     = node.scpr_riakcs.admin_key.to_erl_string
default['riak_cs_control']['config']['riak_cs_control']['cs_admin_secret']  = node.scpr_riakcs.admin_secret.to_erl_string

#----------

include_attribute "riak"

default.riak.package.version.major        = "1"
default.riak.package.version.minor        = "4"
default.riak.package.version.incremental  = "12"
default.riak.package.version.build        = "1"

default['riak']['args']['-name'] = "riak@#{node.name}.node.consul"

default['riak']['config']['riak_kv']['storage_backend'] = 'riak_cs_kv_multi_backend'
default['riak']['data_dir']                             = node.scpr_riakcs.data_dir

default['riak']['config']['riak_control']['enabled']  = true
default['riak']['config']['riak_control']['auth']     = 'none'

default['riak']['cs_version'] = [:major,:minor,:incremental].collect { |v| node['riak_cs']['package']['version'][v] }.join(".")
default['riak']['config']['riak_kv']['add_paths'] = ["/usr/lib/riak-cs/lib/riak_cs-#{node['riak']['cs_version']}/ebin".to_erl_string]

prefix_list = ["0b:".to_erl_binary, "be_blocks"]
be_default  = ["be_default", "riak_kv_eleveldb_backend", {"data_root" => "#{node['riak']['data_dir']}/leveldb".to_erl_string, "max_open_files" => 50}]
be_blocks   = ["be_blocks", "riak_kv_bitcask_backend", {"data_root" => "#{node['riak']['data_dir']}/bitcask".to_erl_string}]

default['riak']['config']['riak_kv']['multi_backend_prefix_list'] = [prefix_list.to_erl_tuple]
default['riak']['config']['riak_kv']['multi_backend_default']     = "be_default"
default['riak']['config']['riak_kv']['multi_backend']             = [be_default.to_erl_tuple, be_blocks.to_erl_tuple]
default['riak']['config']['riak_core']['default_bucket_props']    = [ ['allow_mult', true].to_erl_tuple ]

default['riak']['config']['riak_core']['http']        = ["0.0.0.0".to_erl_string, 8098].to_erl_tuple
default['riak']['config']['riak_core']['cluster_mgr'] = ["0.0.0.0".to_erl_string, 9085].to_erl_tuple
default['riak']['config']['riak_api']['pb']           = ["0.0.0.0".to_erl_string, 8087].to_erl_tuple

default['riak']['config']['riak_api']['pb_backlog'] = 256

#----------

include_attribute "riak-cs::stanchion"

default['stanchion']['args']['-name'] = "stanchion@#{node.name}.node.consul"
default['stanchion']['config']['stanchion']['admin_key'] = node.scpr_riakcs.admin_key.to_erl_string
default['stanchion']['config']['stanchion']['admin_secret'] = node.scpr_riakcs.admin_secret.to_erl_string

default['stanchion']['config']['stanchion']['riak_ip'] = node.scpr_riakcs.ip.to_erl_string
default['stanchion']['config']['stanchion']['stanchion_ip'] = "0.0.0.0".to_erl_string