# etcd-conductor

Ansible-based etcd manager. Offers convenient and no-hassle install,
bootstrap, management and health check operations.


  * [etcd-conductor](#etcd-conductor)
    * [What is etcd-conductor?](#what-is-etcd-conductor)
    * [What it is not?](#what-it-is-not)
    * [Quickstart: 1 minute to operational etcd cluster](#quickstart-1-minute-to-operational-etcd-cluster)
    * [Supported Linux distributions](#supported-linux-distributions)
    * [Contributing](#contributing)
    * [License](#license)
    * [Credits](#credits)



## What is etcd-conductor?

etcd-conductor is Ansible-based etcd cluster manager and deployment tool.
It can install etcd on your designated hosts, bootstrap your new cluster,
start, stop and restart it, rolling-restart it, reconfigure it, check
its health and get its leader, add and remove nodes to/from it, and so
forth.



## What it is not?

Currently etcd-conductor is not concerned with data that is stored in your
etcd cluster - at all! This might change in the future, but one should not
expect that eagerly.



## Quickstart: 1 minute to operational etcd cluster

```bash
# Create a new git repository.
git init my-etcd-cluster
cd       my-etcd-cluster


# Add etcd-conductor as git submodule to it.
# WARNING: It is important that you do not change the submodule path!
git submodule add https://github.com/a2o/etcd-conductor.git etcd-conductor


# Let etcd-conductor bootstrap your git repository contents.
./etcd-conductor/bootstrap-parent-git.sh


# Populate your inventory now.
edit ./hosts


# If you do not have etcd already installed on your nodes,
# etcd-conductor can do it for you.
# Destination: /usr/local/etcd*
./bin/install


# Finish: bootstrap your cluster.
./bin/cluster-bootstrap
```



## Supported Linux distributions

etcd-conductor is created as distribution-agnostic as possible. Currently the
following distributions are supported: Ubuntu, Slackware, RedHat/CentOS.
If you need support for some other Linux distribution, please create it and
submit a pull request.

Parts that need polishing:
- install procedure (currently supports Ubuntu only)
- active cluster management (restart commands might be missing)



## Contributing

Contributions to etcd-conductor in form of pull requests on GitHub are welcome.
Please use concise branch naming for your pull requests. Same branching and
contributing rules apply as described here:
- pull request branch naming: https://github.com/a2o/snoopy/blob/master/doc/CONTRIBUTING.md#git-branches---transient
- creating pull requests: https://github.com/a2o/snoopy/blob/master/doc/CONTRIBUTING.md#creating-pull-requests-for-upstream-merges



## License

etcd-conductor is released under GNU General Public License version 2.



## Credits

etcd-conductor development is currently located at the following URI:

    http://github.com/a2o/etcd-conductor/

etcd-conductor was created and is maintained by:

    Bostjan Skufca <bostjan@a2o.si>

List of contributors is available at the following locations:
- in the git history;
- in the ChangeLog file;
- in the list of pull requests on GitHub.
