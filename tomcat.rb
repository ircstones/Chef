package 'JDK1.7' do
	package_name 'java-1.7.0-openjdk-devel'
end

group 'tomcat' do
  	group_name 'tomcat'
  	action :create
end

user 'name' do
  gid 'tomcat'
  home '/opt/tomcat'
  manage_home true
  shell '/bin/nologin'
  username 'tomcat'
  action :create
end

remote_file '/tmp/apache-tomcat-8.5.29.tar.gz' do
  source 'https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.29/bin/apache-tomcat-8.5.29.tar.gz'
  mode '0755'
  action :create
end

execute 'untar_tomcat' do
  command 'tar xzvf /tmp/apache-tomcat-8.5.29.tar.gz --strip-components=1'
  cwd '/opt/tomcat'
end

execute 'chgrp-ownership-to-tomcat' do
  command 'chgrp -R tomcat /opt/tomcat'
  action :run
end

execute 'chmod-conf-grp-recursively' do
  command 'chmod -R g+r /opt/tomcat/conf'
  user 'root'
  action :run
end

execute 'chmod-conf-group-withx' do
  command 'chmod g+x /opt/tomcat/conf'
  action :run
end

    execute 'recursive chowns of dirs' do
        command 'chown -R tomcat /opt/tomcat/webapps && chown -R tomcat /opt/tomcat/work && chown -R tomcat /opt/tomcat/temp && chown -R tomcat /opt/tomcat/logs'
    end

file '/etc/systemd/system/tomcat.service' do
  content "# Systemd unit file for tomcat
[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/bin/kill -15 $MAINPID

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target"
end

service 'systemd' do
	action :reload
end

service 'tomcat' do
	action [:enable, :start]
end
