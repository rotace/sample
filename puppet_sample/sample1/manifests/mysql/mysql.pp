
####  setup mysql #####
# if you don't use the module
# please use these config

package { 'mysql':
  ensure  => installed,
}
package { 'mysql-server':
  ensure  => installed,
  require => Package['mysql'],
}
package { 'mysql-devel':
  ensure  => installed,
  require => Package['mysql-server'],
}
file { '/etc/my.cnf':
  ensure   => present,
  owner    => 'root',
  group    => 'root',
  mode     => '0644',
  content  => template('my.cnf'),
  require  => Package['mysql-devel'],
  notify   => Service['mysqld'],
}
service { 'mysqld':
  enable     => true,
  ensure     => running,
  hasrestart => true,
}

# after that, you need to setup "mysql_secure_installation"




####  setup mysql (by puppetlabs/mysql) #####
#
# if you want to use the module 'puppetlabs/mysql'
# fisrt you should install the module
# by excuting the command '#puppet module install puppetlabs/mysql --version 0.9.0'
# (v0.9.0 works well on centOS6.5)


# class { '::mysql::server':
#   root_password    => 'mysqlpass',
#   override_options => {
#     'mysqld' => {
#       'character-set-server'  => 'utf8',
#     },
#     'mysql'  => {
#       'default-character-set' => 'utf8',
#     },
#   }
# }

# # in this section, you need setup "mysql_secure_installation"

# mysql_database { 'db_redmine':
#   ensure  => 'present',
#   charset => 'utf8',
# }

# mysql_grant { 'user_redmine@localhost/db_redmine.*':
#   ensure     => 'present',
#   options    => ['GRANT'],
#   privileges => ['ALL'],
#   table      => 'db_redmine.*',
#   user       => 'user_redmine@localhost',
# }

  
