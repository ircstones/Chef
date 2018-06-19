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

execute 'recursive-chgrp-to-tomcat' do
  	command 'chgrp -R tomcat /opt/tomcat'
  	action :run
end

execute 'recursive-chmod-grp-conf' do
  	command 'chmod -R g+r /opt/tomcat/conf'
  	user 'root'
  	action :run
end

execute 'chmod-conf-grp-withx' do
  	command 'chmod g+x /opt/tomcat/conf'
  	action :run
end

execute 'recursive-chowns-of-dirs' do
        command 'chown -R tomcat /opt/tomcat/webapps && chown -R tomcat /opt/tomcat/work && chown -R tomcat /opt/tomcat/temp && chown -R tomcat /opt/tomcat/logs'
end

cookbook_file "/etc/systemd/system/tomcat.service" do
	source "tomcat.service"
  	mode "0644"
end

cookbook_file "/opt/tomcat/conf/tomcat-users.xml" do
	source "tomcat-users.xml"
	mode "0644"
end

cookbook_file "/opt/tomcat/webapps/manager/META-INF/context.xml" do
	source "context.xml"
	mode "0644"
end

service 'systemd' do
	action :reload
end

service 'tomcat' do
	action [:enable,:start]
end
