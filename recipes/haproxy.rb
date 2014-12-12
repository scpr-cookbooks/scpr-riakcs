# -- Install HAProxy -- #

#include_recipe "haproxy::install_package"

include_recipe "apt"

apt_repository "haproxy" do
  uri     'http://ppa.launchpad.net/vbernat/haproxy-1.5/ubuntu'
  distribution  node['lsb']['codename']
  components    ['main']
  keyserver     "keyserver.ubuntu.com"
  key           "1C61B9CD"
  action        :add
end

package "haproxy" do
  action :install
  version "1.5.9-1ppa1~precise"
end

service "haproxy" do
  action :nothing
  supports [:start,:stop,:restart,:reload,:status]
end

# write the defaults file enabling haproxy
#cookbook_file "/etc/default/haproxy" do
#  cookbook  "haproxy"
#  source    "haproxy-default"
#  owner     "root"
#  group     "root"
#  mode      00644
#  notifies  :restart, "service[haproxy]"
#end

# -- Install / Configure Consul -- #

include_recipe "scpr-consul"

# -- Install consul template -- #

include_recipe "consul-template"

# -- Write out our consul_template template -- #

# find the IP address for our admin interface
admin_ip = node.ipaddress

cookbook_file "/etc/ssl/riak.pem" do
  action  :create
  owner   "haproxy"
  mode    0600
end

template "/etc/haproxy/haproxy.tmplt" do
  action :create
  variables({
    admin_ip:   admin_ip,
    pem_path:   "/etc/ssl/riak.pem",
  })
end

# Set up our consul template config
consul_template_config "haproxy" do
  action :create
  templates([
    {
      source:       "/etc/haproxy/haproxy.tmplt",
      destination:  "/etc/haproxy/haproxy.cfg",
      command:      "service haproxy reload",
    }
  ])
end
