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

# Create necessary directories
file { ['/data/web_static/releases/test/', '/data/web_static/shared/']:
  ensure => directory,
  owner  => 'ubuntu',
  group  => 'ubuntu',
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
  recurse => true,
}
