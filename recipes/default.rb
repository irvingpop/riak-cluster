
# first,  install riak
include_recipe 'riak::default'

# second, wait for riak to settle
execute 'wait-for-riak' do
  command "riak-admin wait-for-service riak_kv riak@#{node['fqdn']}"
  timeout 60
  retries 3
end

# then, populate /etc/hosts from search results
def extract_cluster_ip(node_results)
  use_interface = node['riak-cluster']['use_interface']
  node_results['network_interfaces'][use_interface]['addresses']
    .select { |k,v| v['family'] == 'inet' }.keys
end

found_nodes = search(:node, "name:riak*",
  filter_result: {
    'name' => [ 'name' ],
    'fqdn' => [ 'fqdn' ],
    'network_interfaces' => [ 'network', 'interfaces' ]
  }
)

found_nodes.each do |nodedata|
  next if nodedata['network_interfaces'].nil?

  hostsfile_entry extract_cluster_ip(nodedata) do
    hostname nodedata['fqdn']
    aliases [ nodedata['name'] ]
    unique true
    comment 'Chef riak-cluster cookbook'
  end
end

# Phase 3 - join the cluster

# TODO - is this sane or do I need to specify one?
master_server = found_nodes.first

if master_server['name'] == node.name
  log "I am the master, do nothing"
else
  log "Joining the Riak cluster, talking to #{master_server['fqdn']}"

  execute 'Riak cluster join' do
    command "riak-admin cluster join riak@#{master_server['fqdn']}"
    action :run
    notifies :run, 'execute[Riak cluster plan]', :immediately
    not_if "riak-admin status |grep ring_members | grep #{master_server['fqdn']}"
  end

  execute 'Riak cluster plan' do
    command 'riak-admin cluster plan'
    action :nothing
    notifies :run, 'execute[Riak cluster commit]', :immediately
  end

  execute 'Riak cluster commit' do
    command 'riak-admin cluster commit'
    action :nothing
  end
end
