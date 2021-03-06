# Chef Workshop

Installing both MongoDB and Tomcat on a RHEL 7 system

## Getting Started

Pull the repo into /root and run from that exact location

### Prerequisites

This assumes chef-solo on a single system as such:

```
chef-solo  
```

### Installing

To get the system ready for install grab the Chef rpm and install

```
#wget https://packages.chef.io/files/stable/chefdk/3.0.36/el/7/chefdk-3.0.36-1.el7.x86_64.rpm
#rpm -ivh chefdk-3.0.36-1.el7.x86_64.rpm
```

Install Git

```
#yum install -y git
```

Initialize an empty repo in /root

```
#git init
```

Pull the repo

```
#git pull https://github.com/ircstones/Chef
```

## Install the cookbook

* I am not calling the default recipe
* The second recipe installs mongoDB
* The third recipe installs and configures Tomcat

```
#chef-solo -c /root/solo.rb -j /root/startup.json
```
It should take about 1-1.5 minutes to run

## Authors

* **Chris Stone** - [Ircstones](https://github.com/ircstones)


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to the good folks @ Chef for putting the workshop out there!
