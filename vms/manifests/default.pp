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
  command => '/home/vagrant/.rbenv/shims/bundle install',
  cwd     => '/opt/app',
  user    => 'vagrant',
  require => Rbenv::Compile['2.0.0-p247'],
}

