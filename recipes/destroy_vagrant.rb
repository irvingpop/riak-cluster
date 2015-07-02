require 'chef/provisioning/vagrant_driver'

base_dir = ::File.join(::File.dirname(__FILE__), '..')
vms_dir = ::File.join(base_dir, 'vagrants')

log "base dir is #{base_dir}, #{vms_dir}"

directory vms_dir
vagrant_cluster vms_dir

with_chef_local_server :chef_repo_path => base_dir,
  :cookbook_path => [ File.join(base_dir, 'vendor') ],
  :port => 9010.upto(9999)

machine_batch do
  action :destroy
  machines search(:node, '*:*').map { |n| n.name }
end
