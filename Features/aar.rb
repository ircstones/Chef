##Installing apache2, mysql, and unzip

%w{apache2, mysql-server, unzip}.each do |pkg|
    package pkg do
        action: [install, upgrade]
    end
end

remote_file '/tmp/master.zip' do
  	source 'https://github.com/colincam/Awesome-Appliance-Repair/archive/master.zip'
  	mode '0755'
    not_if { File.exists?("/tmp/master.zip") }
end

execute 'unzip_master' do
  	command 'unzip /tmp/master.zip'
  	cwd '/root/'
	not_if { File.exists?("/root/Awesome-Appliance-Repair-master/AARinstall.py") }
end

remote_directory 'mv_ARR_to_www' do
    	path '/root/Awesome-Appliance-Repair-master/AAR/'
    	source '/var/www/AAR/'
     	 not_if { File.exists?("/var/www/AAR/robots.txt") }
end

excute 'Run_ARRinstall' do
  command 'python AARinstall.py'
  cwd '/root/Awesome-Appliance-Repair/'
  user 'root'
end

excute 'Start_apache_gracefully' do
  command 'apachectl graceful'
end
  
