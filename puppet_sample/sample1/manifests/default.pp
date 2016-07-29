
#### define variable ####
$usr = 'vagrant'

#### default setting ####
Exec {
  path  => ['/usr/sbin','/usr/bin','/sbin','/bin'],
  group => 'root',
  user  => 'root',
}



#### STAGE: preinstall ###################################

stage { 'preinstall':
  before => Stage['main']
}

# trigger
class trigger {
  package { ['gcc-c++','gcc-gfortran']:  ensure => installed }
}

#--- gui tool --------------------

class guitools {

    Exec {
    refreshonly => true,
    subscribe   => Package['gcc-c++'],
  }

  exec {
    'guitools-X11':
      command => "yum -y groupinstall 'X Window System'";
    'guitools-desk':
      command => "yum -y groupinstall 'Desktop'";
    'guitools-general':
      command => "yum -y groupinstall 'General Purpose Desktop'";
    'fonts':
      command => "yum -y groupinstall 'Fonts'";
    'inittab':
      command => "sed -i -e 's/id:3/id:5/' /etc/inittab";
  }
}


#--- keyboard setting -------------

class keyboard {

  Exec {
    refreshonly => true,
    subscribe   => Package['gcc-c++'],
  }

  $path = "/etc/sysconfig/keyboard"

  exec {
    'keyboard1':
      command => "sed -i -e 's/KEYTABLE=\"us\"/KEYTABLE=\"jp106\"/' $path";
    'keyboard2':
      command => "sed -i -e 's/MODEL=\"pc105+inet\"/MODEL=\"jp106\"/' $path";
    'keyboard3':
      command => "sed -i -e 's/LAYOUT=\"us\"/LAYOUT=\"jp\"/' $path";
  }
}


#--- selinux disabled -------------

class selinux {

  Exec {
    refreshonly => true,
    subscribe   => Package['gcc-c++'],
  }

  exec { 'slconfig':
    command => "sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config",
  }
}


#--- Japanese support -------------

class japanese {

  Exec {
    refreshonly => true,
    subscribe   => Package['gcc-c++'],
  }

  exec {
    'japanese-support':
      command => "yum -y groupinstall 'Japanese Support'";
    'i18n':
      command => "sed -i -e 's/LANG=\"en_US.UTF-8\"/LANG=\"ja_JP.UTF-8\"/' /etc/sysconfig/i18n";
  }
}

#--- excute stege:preinstall ---

class {	['trigger','guitools','keyboard','selinux','japanese']:
  stage => preinstall
}

#### STAGE: main #############################################

#--- emacs23.1 ------------------

package { 'emacs': ensure => installed }

class emacs-usr {
  $home = "/home/${usr}/"

  Exec {
    group       => "${usr}",
    user        => "${usr}",
    refreshonly => true,
    subscribe   => Package['emacs'],
  }

  exec {
    'emacs.d':
      command => "git clone https://github.com/rotace/.emacs.d.git ${home}/.emacs.d";
    'bashrc1':
      command   => "echo 'alias ed=\"emacs --daemon\"' >> ${home}/.bashrc ";
    'bashrc2':
      command => "echo \'alias ee=\"emacsclient -e '\\''(kill-emacs)'\\''\"' >> ${home}/.bashrc ";
    'bashrc3':
      command => "echo 'alias ec=\"emacsclient -c\"' >> ${home}/.bashrc ";    
  }
}


class emacs-root {
  $home = "/root"

  Exec {
    group       => "root",
    user        => "root",
    refreshonly => true,
    subscribe   => Package['emacs'],
  }

  exec {
    'emacs.d-r':
      command => "git clone https://github.com/rotace/.emacs.d.git ${home}/.emacs.d";
    'bashrc1-r':
      command   => "echo 'alias ed=\"emacs --daemon\"' >> ${home}/.bashrc ";
    'bashrc2-r':
      command => "echo \'alias ee=\"emacsclient -e '\\''(kill-emacs)'\\''\"' >> ${home}/.bashrc ";
    'bashrc3-r':
      command => "echo 'alias ec=\"emacsclient -c\"' >> ${home}/.bashrc ";    
  }
}

class {
  'emacs-usr':;
  'emacs-root':;
}


