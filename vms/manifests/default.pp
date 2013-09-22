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
