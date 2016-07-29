# /etc/sysconfig/network edit
file { '/etc/sysconfig/network':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',            # -rw-r--r--.
  content => template('network'),
  notify  => Service['network'],
}
service { 'network':
  enable     => true,
  ensure     => running,
  hasrestart => true,
  require    => File['/etc/sysconfig/network'],
}


# /etc/sysconfig/selinux edit

file { '/etc/selinux/config':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => template('selinux'),
}

# /etc/sysconfig/iptables edit
file { '/etc/sysconfig/iptables':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0600',
  content => template('iptables'),
  notify  => Service['iptables'],
}
service { 'iptables':
  enable     => true,
  ensure     => running,
  hasrestart => true,
  require    => File['/etc/sysconfig/iptables'],
}
