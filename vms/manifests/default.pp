exec { "apt-update":
  command => "/usr/bin/apt-get update"
}

Exec["apt-update"] -> Package <| |>

rbenv::install { "vagrant":
  group => 'vagrant',
  home  => '/home/vagrant'
}

rbenv::compile { "2.0.0-p247":
  user => "vagrant",
  home => "/home/vagrant",
}
exec { 'bundle install':
  command  => '/home/vagrant/.rbenv/shims/bundle install',
  cwd      => '/opt/app',
  user     => 'vagrant',
  require  => Rbenv::Compile['2.0.0-p247'],
}

exec { "rehash":
  # Infernal hack to force login shell
  command  => "/bin/su -c '/home/vagrant/.rbenv/bin/rbenv rehash' - vagrant",
  user     => 'root',
  cwd      => '/opt/app',
  require  => Exec['bundle install'],
}

exec { 'foreman export':
  command    => '/usr/bin/sudo /home/vagrant/.rbenv/shims/foreman export upstart -p 9292 --app=wtface --user=vagrant /etc/init',
  cwd        => '/opt/app',
  user       => 'vagrant',
  require  => Exec['rehash'],
}

service { 'wtface':
  name   => 'wtface',
  ensure => 'running',
  enable => true,
  require => Exec['foreman export'],
}
