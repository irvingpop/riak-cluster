task :default => [:up]

task :up => :setup do
  sh('chef-client -z recipes/provision_vagrant.rb ')
end

task :setup do
  unless Dir.exist?('vendor')
    sh('berks install --quiet')
    Dir.mkdir('vendor')
    sh('berks vendor vendor/ --quiet')
  else
    sh('berks update --quiet')
    sh('berks vendor vendor/ --quiet')
  end
end

task :destroy do
  sh('chef-client -z recipes/destroy_vagrant.rb ')
end
task :cleanup => :destroy
