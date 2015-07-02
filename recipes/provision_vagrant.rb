#
# Cookbook Name:: riak-cluster
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'chef/provisioning/vagrant_driver'

base_dir = ::File.join(::File.dirname(__FILE__), '..')
vms_dir = ::File.join(base_dir, 'vagrants')

log "base dir is #{base_dir}, #{vms_dir}"

directory vms_dir
vagrant_cluster vms_dir

with_chef_local_server :chef_repo_path => base_dir,
  :cookbook_path => [ File.join(base_dir, 'vendor') ],
  :port => 9010.upto(9999)

riak_nodes = 3

vagrant_config = <<-ENDCONFIG
  config.vm.network 'private_network', type: 'dhcp'
  config.vm.provider 'virtualbox' do |v|
    v.customize [
      'modifyvm', :id,
      '--memory', "1024",
      '--cpus', "2",
      '--natdnshostresolver1', 'on',
      '--usb', 'off',
      '--usbehci', 'off'
    ]
  end
ENDCONFIG

machine_batch 'precreate' do
  action [:converge]

  1.upto(riak_nodes) do |i|
    machine "riak#{i}" do
      recipe 'riak-cluster::default'
      attribute 'riak-cluster', { use_interface: 'eth1' }
      machine_options vagrant_options: {
        'vm.box' => 'opscode-ubuntu-14.04',
        'vm.box_url' => 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box',
        'vm.hostname' => "riak#{i}.example.com"
      }, vagrant_config: vagrant_config
    end
  end
end
