name             'scpr-riakcs'
maintainer       'Southern California Public Radio'
maintainer_email 'erichardson@scpr.org'
license          'apache2'
description      'Installs/Configures scpr-riakcs'
long_description 'Installs/Configures scpr-riakcs'
version          '0.2.0'

depends 'scpr-consul'
depends 'riak'
depends 'riak-cs', "~> 2.2.10"

depends 'apt'

depends 'haproxy'
depends 'consul-template'
