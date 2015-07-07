cluster_nodes_count = 3
default['riak-cluster']['cluster_nodes'] = 1.upto(cluster_nodes_count).map { |i| "riak#{i}.example.com" }
default['riak-cluster']['use_interface'] = 'eth0'

default['riak']['config']['listener']['http']['internal'] = "0.0.0.0:8098"
default['riak']['config']['listener']['protobuf']['internal'] = "0.0.0.0:8087"

default['riak']['package']['version']['major'] = '2'
default['riak']['package']['version']['minor'] = '1'
default['riak']['package']['version']['incremental'] = '1'

# Provisiong driver settings
default['riak-cluster']['provisioning']['driver'] = 'vagrant'

default['chef-provisioning-vagrant']['vbox']['ram'] = 512
default['chef-provisioning-vagrant']['vbox']['cpus'] = 1
default['chef-provisioning-vagrant']['vbox']['private_networks']['default'] = 'dhcp'
