#
# Cookbook Name:: riak-cluster
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'chef-provisioning-vagrant-helper::default'

riak_nodes = 3

machine_batch 'precreate' do
  action [:converge]

  1.upto(riak_nodes) do |i|
    machine "riak#{i}" do
      recipe 'riak-cluster::default'
      attribute 'riak-cluster', { use_interface: 'eth1' }
      machine_options vagrant_options("riak#{i}.example.com")
      # see chef-provisioning-vagrant-helper/libraries/vagrant_config.rb
    end
  end
end
