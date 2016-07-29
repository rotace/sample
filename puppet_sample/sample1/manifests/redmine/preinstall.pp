# dependency packages install

Exec {
  path => ['/usr/sbin','/usr/bin','/sbin','/bin'],
  group=> 'root',
  user => 'root',
}

package { 'libyaml-devel':
    ensure          => installed,
    install_options => ['--nogpgcheck','--enablerepo=epel'],
}

package {
  ['openssl-devel','readline-devel','zlib-devel','libcurl-devel']:
    ensure         => installed,
    install_options => ['--nogpgcheck'];
  ['ImageMagick','ImageMagick-devel','ipa-pgothic-fonts']:
    ensure         => installed,
    install_options => ['--nogpgcheck'];
}

package { ['ruby-devel','rubygems']:
  ensure         => installed,
  install_options => ['--nogpgcheck'],
}

exec { 'bundler':
  command    => 'gem install bundler',
  refreshonly => true,
  subscribe  => Package['rubygems'],
}

