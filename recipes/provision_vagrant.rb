#
# Cookbook Name:: riak-cluster
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'chef-provisioning-vagrant-helper::default'

machine_batch 'precreate' do
  action [:converge]

  node['riak-cluster']['cluster_nodes'].each do |vmname|
    machine vmname do
      recipe 'riak-cluster::default'
      attribute 'riak-cluster', { use_interface: 'eth1' }
      machine_options vagrant_options(vmname)
      # see chef-provisioning-vagrant-helper/libraries/vagrant_config.rb
    end
  end
end
