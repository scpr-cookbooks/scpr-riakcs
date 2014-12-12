
default.scpr_riakcs.consul_service  = "s3"
default.scpr_riakcs.admin_key       = "42-MRE-4FITERWUZ5JA4"
default.scpr_riakcs.admin_secret    = "DlBE3mngF0LEUUvABbb1zRlUvLcEYYt_GtPNLw=="
default.scpr_riakcs.root_host       = "s3.i.scprdev.org"

include_attribute 'riak-cs'

default.riak_cs.package.version.major       = "1"
default.riak_cs.package.version.minor       = "5"
default.riak_cs.package.version.incremental = "2"
default.riak_cs.package.version.build       = "1"

default['riak_cs']['args']['-name'] = "riak-cs@#{node.name}.node.consul"

default['riak_cs']['config']['riak_cs']['stanchion_ip'] = '10.100.0.250'.to_erl_string

default['riak_cs']['config']['riak_cs']['cs_root_host']                 = node.scpr_riakcs.root_host.to_erl_string
default['riak_cs_control']['config']['riak_cs_control']['cs_hostname']  = node.scpr_riakcs.root_host.to_erl_string

default['riak_cs']['config']['riak_cs']['cs_port'] = 8080

#default['riak_cs']['config']['riak_cs']['ssl'] = [
#  ["certfile",    "/etc/ssl/riak-cert.pem".to_erl_string].to_erl_tuple,
#  ["keyfile",     "/etc/ssl/riak-key.pem".to_erl_string].to_erl_tuple,
#  ["cacertfile",  "/etc/ssl/riak-cacert.pem".to_erl_string].to_erl_tuple
#]

default['riak_cs_control']['config']['riak_cs_control']['cs_proxy_host']  = node.scpr_riakcs.root_host.to_erl_string
default['riak_cs_control']['config']['riak_cs_control']['cs_proxy_port']  = 8080
default['riak_cs_control']['config']['riak_cs_control']['cs_port']        = 8080

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

default.riak.args['-name'] = "riak@#{node.name}.node.consul"

default.riak.config.riak_kv.storage_backend = 'riak_cs_kv_multi_backend'
default.riak.data_dir = "/data/riak"
default['riak']['config']['riak_control']['enabled'] = true
default['riak']['config']['riak_control']['auth'] = 'none'

default['riak']['cs_version'] = "1.5.2"
if node['platform_family'] == "rhel" && node['kernel']['machine'] == "x86_64"
   default['riak']['config']['riak_kv']['add_paths'] = ["/usr/lib64/riak-cs/lib/riak_cs-#{node['riak']['cs_version']}/ebin".to_erl_string]
else
   default['riak']['config']['riak_kv']['add_paths'] = ["/usr/lib/riak-cs/lib/riak_cs-#{node['riak']['cs_version']}/ebin".to_erl_string]
end
prefix_list = ["0b:".to_erl_binary, "be_blocks"]
default['riak']['config']['riak_kv']['multi_backend_prefix_list'] = [prefix_list.to_erl_tuple]
default['riak']['config']['riak_kv']['multi_backend_default'] = "be_default"
be_default = ["be_default", "riak_kv_eleveldb_backend", {"data_root" => "#{node['riak']['data_dir']}/leveldb".to_erl_string, "max_open_files" => 50}]
be_blocks = ["be_blocks", "riak_kv_bitcask_backend", {"data_root" => "#{node['riak']['data_dir']}/bitcask".to_erl_string}]
default['riak']['config']['riak_kv']['multi_backend'] = [be_default.to_erl_tuple, be_blocks.to_erl_tuple]
default['riak']['config']['riak_core']['default_bucket_props'] = [ ['allow_mult', true].to_erl_tuple ]

default['riak']['config']['riak_core']['https'] = [["#{node['ipaddress']}".to_erl_string, 8498].to_erl_tuple]

default['riak']['config']['riak_core']['ssl'] = [
  ["certfile",    "/etc/ssl/riak-cert.pem".to_erl_string].to_erl_tuple,
  ["keyfile",     "/etc/ssl/riak-key.pem".to_erl_string].to_erl_tuple,
  ["cacertfile",  "/etc/ssl/riak-cacert.pem".to_erl_string].to_erl_tuple
]

#----------

include_attribute "riak-cs::stanchion"

default['stanchion']['args']['-name'] = "stanchion@#{node.name}.node.consul"
default['stanchion']['config']['stanchion']['admin_key'] = node.scpr_riakcs.admin_key.to_erl_string
default['stanchion']['config']['stanchion']['admin_secret'] = node.scpr_riakcs.admin_secret.to_erl_string