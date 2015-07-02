current_dir       = ::File.dirname(__FILE__)
chef_repo_path    ::File.join(current_dir, '..')
cookbook_path     ::File.join(current_dir, '..')
node_name         'cluster-provisioner'
file_cache_path   File.join(current_dir, 'local-mode-cache', 'cache')
