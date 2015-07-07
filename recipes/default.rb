
# first,  install riak
include_recipe 'riak::default'

# second, wait for riak to settle
execute 'wait-for-riak' do
  command "riak-admin wait-for-service riak_kv riak@#{node['fqdn']}"
  timeout 60
  retries 3
  subscribes :run, 'service[riak]', :immediately
end

# third, populate /etc/hosts from search results
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
).reject { |nodedata| nodedata['network_interfaces'].nil? } #not if no interface data
  .reject { |nodedata| nodedata['name'] == node.name } # not if it's me

found_nodes.each do |nodedata|
  hostsfile_entry extract_cluster_ip(nodedata) do
    hostname nodedata['fqdn']
    aliases [ nodedata['name'] ]
    unique true
    comment 'Chef riak-cluster cookbook'
  end
end

# Finally - join the cluster if applicable
if found_nodes.count == 0
  log "I am the first one here, do nothing"
else
  pick_a_node = found_nodes.sample # pick one at random, not me
  log "Joining the Riak cluster, talking to #{pick_a_node['fqdn']}"

  execute 'Riak cluster join' do
    command "riak-admin cluster join riak@#{pick_a_node['fqdn']}"
    action :run
    notifies :run, 'execute[Riak cluster plan]', :immediately
    not_if "riak-admin member-status | grep ^valid | grep #{pick_a_node['fqdn']}"
    retries 6  # retry logic needed for cluster node replacement
    retry_delay 30
  end

  execute 'Riak cluster plan' do
    command 'riak-admin cluster plan'
    action :nothing
    notifies :run, 'execute[Riak cluster commit]', :immediately
    retries 6
    retry_delay 30
  end

  execute 'Riak cluster commit' do
    command 'riak-admin cluster commit'
    action :nothing
    retries 6
    retry_delay 30
  end
end
