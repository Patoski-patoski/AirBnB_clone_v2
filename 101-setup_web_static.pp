# A manifest that sets up your web servers for the deployment of web_static

class web_server_setup {
  # ensure nginx is installed
  package { 'nginx':
    ensure => installed,
}

# Create the /data/web_static/releases/test directory
file { '/data/web_static/releases/test':
  ensure => directory,
  owner  => 'ubuntu',
  group  => 'ubuntu',
  mode   => '0755',
}

# Create the /data/web_static/shared directory
file { '/data/web_static/shared':
  ensure => directory,
  owner  => 'ubuntu',
  group  => 'ubuntu',
  mode   => '0755',
}

# Create a fake HTML file /data/web_static/releases/test/index.html
file { '/data/web_static/releases/test/index.html':
  ensure  => file,
  owner   => 'ubuntu',
  group   => 'ubuntu',
  mode    => '0644',
  content => '<html><head></head><body>Holberton School</body></html>'
}

# Create a symbolic link /data/web_static/current linked to the
# /data/web_static/releases/test/ folder
file { '/data/web_static/current':
  ensure => symlink,
  target => '/data/web_static/releases/test/',
  owner  => 'ubuntu',
  group  => 'ubuntu',
}

# Give ownership of the /data/ folder to the ubuntu user AND group
file { '/data':
  ensure  => directory,
  owner   => 'ubuntu',
  group   => 'ubuntu',
  recurse => true,
}

# Update the Nginx configuration to serve the content of
# /data/web_static/current/ to hbnb_static

file { '/etc/nginx/sites-available/default':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  notify  => Service['nginx'],
  require => Package['nginx'],
  content => template('web_server_setup/nginx_config.erb'),
}

# Ensure Nginx service is running
service { 'nginx':
  ensure => running,
