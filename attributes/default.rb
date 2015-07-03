

default['riak-cluster']['use_interface'] = 'eth0'

default['riak']['config']['listener']['http']['internal'] = "0.0.0.0:8098"
default['riak']['config']['listener']['protobuf']['internal'] = "0.0.0.0:8087"

default['riak']['package']['version']['major'] = '2'
default['riak']['package']['version']['minor'] = '1'
default['riak']['package']['version']['incremental'] = '1'
