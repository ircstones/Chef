#
# Cookbook:: mongoTom
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
 execute 'update-RHEL' do
 	command 'yum upgrade -y && yum update -y'
 end
