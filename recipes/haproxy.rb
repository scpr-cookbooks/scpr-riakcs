# -- Install HAProxy -- #

node.set['scpr_consul_haproxy']['template'] = "haproxy.tmplt.erb"
node.set['scpr_consul_haproxy']['template_cookbook'] = "scpr-riakcs"

include_recipe "scpr-consul-haproxy"
