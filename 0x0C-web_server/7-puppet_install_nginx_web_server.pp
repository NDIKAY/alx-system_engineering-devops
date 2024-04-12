# Puppet manifest to configure Nginx

# Install Nginx package
package { 'nginx':
    ensure => installed,
}

# Ensure Nginx service is running and enabled
service { 'nginx':
    ensure     => running,
    enable     => true,
    require    => Package['nginx'],
}

# Create the default Nginx configuration file with a 301 redirect and Hello World page
file { '/etc/nginx/sites-available/default':
    ensure  => file,
    content => epp('nginx_config/default.epp'), # This uses an Embedded Puppet template
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['nginx'],
    notify  => Service['nginx'],
}

# Create an Embedded Puppet (EPP) template for the default Nginx config
# Save this as /etc/puppetlabs/puppet/modules/nginx_config/templates/default.epp
# <%#
# server {
#     listen 80 default_server;
#     root /var/www/html;
#     index index.html index.htm index.nginx-debian.html;

#     location / {
#         try_files $uri $uri/ =404;
#     }

#     location /redirect_me {
#         return 301 /;
#     }
    
#     location / {
#         default_type "text/html";
#         return 200 "Hello World!\n";
#     }

#     error_page 404 /404.html;
#     location = /404.html {
#         root /usr/share/nginx/html;
#     }
# }
# %>

# Ensure the index file contains "Hello World!"
file { '/var/www/html/index.html':
    ensure  => file,
    content => 'Hello World!\n',
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    require => Package['nginx'],
    notify  => Service['nginx'],
}

