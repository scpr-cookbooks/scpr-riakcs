# -- Install HAProxy -- #

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
end

service "haproxy" do
  action :nothing
  supports [:start,:stop,:restart,:reload,:status]
end

# -- Install / Configure Consul -- #

include_recipe "scpr-consul"

# -- Install consul template -- #

include_recipe "consul-template"

# -- Write out our consul_template template -- #

# find the IP address for our admin interface
admin_ip = node.ipaddress

template "/etc/haproxy/haproxy.tmplt" do
  action :create
  variables({
    admin_ip:   admin_ip,
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
