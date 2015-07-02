# riak-cluster Chef cookbook

An MVP Chef cookbook for configuring a Riak cluster, using Chef Provisioning

# Requirements

* ChefDK 0.6.0 or greater
  * Follow [the instructions](https://docs.chef.io/install_dk.html) to set ChefDK as your system Ruby and Gemset
* Vagrant and Virtualbox (for now)

# Using it

Starting up a cluster:
```bash
rake
```

Connecting to your cluster nodes:
```bash
cd vagrants ; vagrant ssh riak1
```

Destroying the cluster
```bash
rake destroy
```

