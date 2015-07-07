#
# Cookbook Name:: riak-cluster
# Recipe:: rolling_rebuild
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'chef-provisioning-vagrant-helper::default'

node['riak-cluster']['cluster_nodes'].each do |vmname|
  machine_execute "#{vmname} leaves the cluster" do
    machine vmname
    command 'riak-admin cluster leave'
  end

  machine_execute "#{vmname} leaves: cluster plan" do
    machine vmname
    command 'riak-admin cluster plan'
  end

  machine_execute "#{vmname} leaves: cluster commit" do
    machine vmname
    command 'riak-admin cluster commit'
  end

  ruby_block "#{vmname} leaves: cluster settle for 60 seconds" do
    block do
      sleep 60
    end
  end

  machine vmname do
    action :destroy
  end

  machine vmname do
    recipe 'riak-cluster::default'
    attribute 'riak-cluster', { use_interface: 'eth1' }
    machine_options vagrant_options(vmname)
  end
end
