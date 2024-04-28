#!/usr/bin/env bash
# a Bash script that sets up your web servers for the deployment of web_static

if [ -L /etc/nginx ]; then
    # Install Nginx if not installed
    sudo apt-get update
    sudo apt-get install -y nginx
    sudo systemctl reload nginx.service
fi

# Restart Nginx
sudo systemctl restart nginx.service

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

# Create a symbolic link to make te site like
if [ -L /etc/nginx/sites-enabled/hbnb.conf ]; then
   sudo  rm /etc/nginx/sites-enabled/hbnb.conf
fi
sudo ln -s /etc/nginx/sites-available/hbnb.conf /etc/nginx/sites-enabled/

# Give ownership of the /data/ folder to the ubuntu user AND group
sudo chown -R ubuntu: /data/

# Test the web server
sudo systemctl reload nginx.service
sudo service nginx restart
