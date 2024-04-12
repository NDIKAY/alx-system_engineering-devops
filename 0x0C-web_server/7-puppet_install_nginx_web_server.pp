# Puppet script to install and configure Nginx server with a root page containing "Hello World!" and a 301 redirect from /redirect_me to root.

# Install Nginx package
package { 'nginx':
    ensure => installed,
}

# Ensure the Nginx service is running and enabled to start on boot
service { 'nginx':
    ensure     => running,
    enable     => true,
    require    => Package['nginx'],
}

# Define the default Nginx configuration file with a 301 redirect from /redirect_me to root and a root page containing "Hello World!"
file { '/etc/nginx/sites-available/default':
    ensure  => file,
    content => template('nginx_config/default.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['nginx'],
    notify  => Service['nginx'],
}

# Create the template file for the Nginx configuration (located in /etc/puppetlabs/puppet/modules/nginx_config/templates/default.erb)
# This is the content of the template file:
# <%# Nginx configuration template %>
# server {
#     listen 80 default_server;
#     server_name _;
#     root /var/www/html;
#     index index.html index.htm;
#
#     location / {
#         try_files $uri $uri/ =404;
#         default_type "text/html";
#         return 200 "Hello World!\n";
#     }
#
#     location /redirect_me {
#         return 301 /;
#     }
#
#     error_page 404 /404.html;
# }

# Ensure the index file contains the text "Hello World!"
file { '/var/www/html/index.html':
    ensure  => file,
    content => 'Hello World!\n',
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    require => Package['nginx'],
    notify  => Service['nginx'],
}


