# variable

# if you can use facter variable "fqdn",
# you don't need to define $address
# and change the file "http.conf"
#  <%= @address %>  =>   <%= fqdn %>
$address = 'localhost.localdomain'



#### setup apache #####

package { 'httpd':
  ensure  => installed,
}
package { 'httpd-devel':
  ensure  => installed,
  require => Package['httpd'],
}
file { '/etc/httpd/conf/httpd.conf':
  ensure   => present,
  owner    => 'root',
  group    => 'root',
  mode     => '0644',
  content  => template('httpd.conf'),
  require  => Package['httpd-devel'],
  notify   => Service['httpd'],
}
service { 'httpd':
  enable     => true,
  ensure     => running,
  hasrestart => true,
}
