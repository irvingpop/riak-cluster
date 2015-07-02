

default['riak-cluster']['use_interface'] = 'eth0'

default['riak']['config']['listener']['http']['internal'] = "0.0.0.0:8098"
default['riak']['config']['listener']['protobuf']['internal'] = "0.0.0.0:8087"
