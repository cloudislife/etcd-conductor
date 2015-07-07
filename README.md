# etcd-conductor

Ansible-based etcd cluster deployment tool.


  * [etcd-conductor](#etcd-conductor)
    * [How to use](#how-to-use)
    * [Credits](#credits)



## How to use

Basic initialization steps include:
- Create new git repository
- Add etcd-conductor as git submodule into etcd-conductor/ directory
- cp etcd-conductor/ansible.cfg ansible.cfg, adjust to your need
- cp etcd-conductor/hosts hosts, populate with hosts
- ln -s etcd-conductor/bin bin
- ./bin/cluster-bootstrap



## TODO!



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
