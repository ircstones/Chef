yum_repository 'MongoDB-Repository' do
  	description 'MongoDB-Repository'
  	baseurl 'https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.6/x86_64/'
  	gpgcheck='1'
  	enabled='1'
  	gpgkey 'https://www.mongodb.org/static/pgp/server-3.6.asc'
  	action :create
end

package 'mongodb-org' do
	package_name 'mongodb-org'
end

service 'mongod' do
	action [:enable, :start]
end

execute 'allow_mongod_port' do
    	command 'semanage port -l |grep -w 27017 && A=`echo $?`
		  if [ "$A" -eq 1 ]; then
		    semanage port -a -t mongod_port_t -p tcp 27017
		  fi'
end
