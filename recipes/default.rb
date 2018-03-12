#
# Cookbook:: tomcat
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved
# 

package 'java-1.7.0-openjdk-devel'

group 'tomcat'

user 'tomcat' do
  manage_home false
  shell '/usr/sbin/nologin'
  group 'tomcat'
  home '/opt/tomcat'
end

remote_file 'apache-tomcat-8.5.29.tar.gz' do
  source 'http://apache.spinellicreations.com/tomcat/tomcat-8/v8.5.29/bin/apache-tomcat-8.5.29.tar.gz'
end

tomcat_dir = '/opt/tomcat'

directory tomcat_dir do
  group 'tomcat'
end

execute "tar xvf apache-tomcat-8.5.29.tar.gz -C #{tomcat_dir} --strip-components=1"

execute "chmod g+r #{tomcat_dir}/conf/*"

%w[bin webapps work temp logs conf lib].each do |sub_dir|
  execute "chown -R tomcat #{tomcat_dir}/#{sub_dir}"
end

template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
end

execute 'systemctl daemon-reload'

service 'tomcat' do
  action [:start, :enable]
end
