# install priority plugin
package { 'yum-plugin-priorities':
  provider => "yum",
  ensure   => "installed",
}

# set-repo "CentOS-Base"
file { '/etc/yum.repos.d/CentOS-Base.repo':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => template('CentOS-Base.repo'),
  require => Package['yum-plugin-priorities'],
}
  

# set-repo "rpmforge"
file { '/etc/yum.repos.d/rpmforge.repo':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => template('rpmforge.repo'),
  require => Package['yum-plugin-priorities'],
}
file { '/etc/yum.repos.d/mirrors-rpmforge':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => template('mirrors-rpmforge'),
  require => Package['yum-plugin-priorities'],
}
file { '/etc/yum.repos.d/mirrors-rpmforge-extras':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => template('mirrors-rpmforge-extras'),
  require => Package['yum-plugin-priorities'],
}
file { '/etc/yum.repos.d/mirrors-rpmforge-testing':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => template('mirrors-rpmforge-testing'),
  require => Package['yum-plugin-priorities'],
}

# set-repo "remi"
file { '/etc/yum.repos.d/remi.repo':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => template('remi.repo'),
  require => Package['yum-plugin-priorities'],
}

# set-repo "epel"
file { '/etc/yum.repos.d/epel.repo':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => template('epel.repo'),
  require => Package['yum-plugin-priorities'],
}
file { '/etc/yum.repos.d/epel-testing.repo':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => template('epel-testing.repo'),
  require => Package['yum-plugin-priorities'],
}

