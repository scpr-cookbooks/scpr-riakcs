name             'scpr-riakcs'
maintainer       'Southern California Public Radio'
maintainer_email 'erichardson@scpr.org'
license          'apache2'
description      'Installs/Configures scpr-riakcs'
long_description 'Installs/Configures scpr-riakcs'
version          '0.2.6'

depends 'scpr-consul', "~> 0.2"
depends 'riak', "2.4.21"
depends 'riak-cs', "2.2.11"

depends 'scpr-consul-haproxy', "~> 0.5"
