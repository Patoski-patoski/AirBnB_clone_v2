#!/usr/bin/env bash
# a Bash script that sets up your web servers for the deployment of web_static

if [ -L /etc/nginx ]; then
    # Install Nginx if not installed
    sudo apt-get update
    sudo apt-get install -y nginx
    sudo service nginx start
fi

# Restart Nginx
sudo service nginx restart

# Create necessary directories
sudo mkdir -p /data/web_static/releases/test/
sudo mkdir -p /data/web_static/shared/

# Create the index.html file
sudo tee /data/web_static/releases/test/index.html << EOF > /dev/null
<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>
EOF

# Create and remove the existing symbolic link if it exists
if [ -L /data/web_static/current ]; then
    rm /data/web_static/current
fi

# Create the new symbolic link for the website
sudo ln -s /data/web_static/releases/test/ /data/web_static/current

sudo tee /etc/nginx/sites-available/hbnb.conf << EOF > /dev/null
server {
        listen 80;
        listen [::]:80;
        server_name www.patoski.tech patoski.tech;
        add_header X-Served-By $HOSTNAME;
        location /hbnb_static/ {
                alias /data/web_static/current/;
                autoindex off;
        }
        index index.html;
}
EOF

# Create a symbolic link to make te site like
if [ -L /etc/nginx/sites-enabled/hbnb.conf ]; then
   sudo  rm /etc/nginx/sites-enabled/hbnb.conf
fi
sudo ln -s /etc/nginx/sites-available/hbnb.conf /etc/nginx/sites-enabled/

# Give ownership of the /data/ folder to the ubuntu user AND group
sudo chown -R ubuntu: /data/

# Test the web server
sudo service nginx restart
