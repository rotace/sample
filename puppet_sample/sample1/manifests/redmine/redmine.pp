$installdir = '/var/lib/redmine'

# set redmine config
file { "${installdir}/config/database.yml":
  ensure   => present,
  owner    => 'apache',
  group    => 'apache',
  mode     => '0644',
  content  => template('database.yml'),
}
file { "${installdir}/config/configuration.yml":
  ensure   => present,
  owner    => 'apache',
  group    => 'apache',
  mode     => '0644',
  content  => template('configuration.yml'),
}
# set apache config for passenger
file { '/etc/httpd/conf.d/passenger.comf':
  ensure   => present,
  owner    => 'root',
  group    => 'root',
  mode     => '0644',
  content  => template('passenger.conf'),
  notify   => Service['httpd'],
} 
service { 'httpd':
  enable     => true,
  ensure     => running,
  hasrestart => true,
}

