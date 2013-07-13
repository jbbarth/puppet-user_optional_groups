Optional groups for Puppet user resource
========================================

This plugin lets you precise optional groups you want to add only if they exist
on the system. This is usually good for human users you want to put in some
groups for comfort reasons or non-essential things. For instance, some logs on
your platform might only be accessible for "staff" group. But not all your
servers have this group defined (you may have heterogeneous environments). In
such case, either you define a custom fact to retrieve your local groups then
use it in your manifests, OR you simply use :

    user { 'jbbarth':
      groups            => ['staff', 'pulse-audio'],
      optional_groups   => 'www-data',
    }

You can also specify an array of values :

    user { 'jbbarth' :
      optional_groups   => ['non-existent', 'mysql', 'foo'],
    }

The output should look like this :

    % sudo puppet apply --execute 'user {"jbbarth": optional_groups => ["non-existent","mysql","foo"]}'
    Notice: /User[jbbarth]/optional_groups: optional_groups changed 'adm,audio,cdrom,dip,lpadmin,plugdev,rvm,sambashare,staff,sudo,users' to 'adm,audio,cdrom,dip,lpadmin,mysql,plugdev,rvm,sambashare,staff,sudo,users'
    Notice: Finished catalog run in 0.38 seconds

**NB** : this attribute is by definition *NOT* idempotent. You may run puppet
multiple times before converging to a stable state.


Implementation
--------------

This extension is heavily based on the work of Dean Wilson :
- https://github.com/deanwilson/puppet-file_ext_attributes
- https://github.com/deanwilson/puppet-file_show_source

Many thanks to him for providing a concrete and correct example of puppet
internals extension from the outside!


Deployment
----------

Install this code as you would any other module and then, if you have a puppet
master, restart it.


License
-------

MIT.
