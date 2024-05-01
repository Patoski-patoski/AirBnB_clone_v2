# Install Nginx if not installed
package { 'nginx':
  ensure => installed,
}

# Restart Nginx
service { 'nginx':
  ensure => running,
  enable => true,
  restart => true,
}

group { 'ubuntu':
  ensure => present,
}

user { 'ubuntu':
  ensure     => present,
  gid        => 'ubuntu',
  home       => '/home/ubuntu',
  shell      => '/bin/bash',
  managehome => true,
}

# Create necessary directories
file { ['/data/web_static/releases/test/', '/data/web_static/shared/']:
  ensure => directory,
  owner  => 'ubuntu',
  group  => 'ubuntu',
  mode   => '0755',
}

class web_server_setup {
  # Ensure Nginx is installed
  package { 'nginx':
    ensure => installed,
  }

  # Create the /data/web_static/releases/test directory
  file { '/data/web_static/releases/test':
    ensure  => directory,
    owner   => 'ubuntu',
    group   => 'ubuntu',
    mode    => '0755',
  }

  # Create the /data/web_static/shared directory
  file { '/data/web_static/shared':
    ensure  => directory,
    owner   => 'ubuntu',
    group   => 'ubuntu',
    mode    => '0755',
  }

  # Create a fake HTML file /data/web_static/releases/test/index.html
  file { '/data/web_static/releases/test/index.html':
    ensure  => file,
    owner   => 'ubuntu',
    group   => 'ubuntu',
    mode    => '0644',
    content => '<html><head></head><body><h1>Adam is almost a Full Stack Software Engineer</h1></body></html>',
  }

  # Create a symbolic link /data/web_static/current linked to the /data/web_static/releases/test/ folder
  file { '/data/web_static/current':
    ensure  => symlink,
    target  => '/data/web_static/releases/test/',
    owner   => 'ubuntu',
    group   => 'ubuntu',
  }

  # Give ownership of the /data/ folder to the ubuntu user AND group
  file { '/data':
    ensure  => directory,
    owner   => 'ubuntu',
    group   => 'ubuntu',
    recurse => true,
  }

  # Update the Nginx configuration to serve the content of /data/web_static/current/ to hbnb_static
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
    enable => true,
  }
}


# Create the index.html file
file { '/data/web_static/releases/test/index.html':
  ensure  => file,
  content => '<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>',
  owner   => 'ubuntu',
  group   => 'ubuntu',
  mode    => '0644',
}

# Create and remove the existing symbolic link if it exists
file { '/data/web_static/current':
  ensure => 'link',
  target => '/data/web_static/releases/test/',
}

# Create the nginx configuration
file { '/etc/nginx/sites-available/hbnb.conf':
  ensure => file,
  content => 'server {
        listen 80;
        listen [::]:80;
        server_name www.patoski.tech patoski.tech;
        add_header X-Served-By $HOSTNAME;
        location /hbnb_static/ {
                alias /data/web_static/current/;
                autoindex off;
        }
        index index.html;
}',
}

# Create a symbolic link to make te site like
file { '/etc/nginx/sites-enabled/hbnb.conf':
  ensure => symlink,
  target => '/etc/nginx/sites-available/hbnb.conf',
}

# Give ownership of the /data/ folder to the ubuntu user AND group
file { '/data/':
  ensure => directory,
  owner  => 'ubuntu',
  group  => 'ubuntu',
  mode   => '0755',
  recurse => true,
}
