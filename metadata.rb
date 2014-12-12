name             'scpr-riakcs'
maintainer       'Southern California Public Radio'
maintainer_email 'erichardson@scpr.org'
license          'all_rights'
description      'Installs/Configures scpr-riakcs'
long_description 'Installs/Configures scpr-riakcs'
version          '0.1.7'

depends 'scpr-consul'
depends 'riak'
depends 'riak-cs', "~> 2.2.10"

depends 'apt'

depends 'haproxy'
depends 'consul-template'
