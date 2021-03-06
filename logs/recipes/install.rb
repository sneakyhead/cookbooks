directory "/opt/aws/cloudwatch" do
 recursive true
end

remote_file "/opt/aws/cloudwatch/awslogs-agent-setup-v1.0.py" do
source "https://s3.amazonaws.com/aws-cloudwatch/downloads/awslogs-agent-setup-v1.0.py"
mode "0755"
end

execute "Install CloudWatch Logs agent" do
command "/opt/aws/cloudwatch/awslogs-agent-setup-v1.0.py -n -r us-east-1 -c /tmp/cwlogs.cfg"
not_if { system "pgrep -f aws-logs-agent-setup" }
end

file '/etc/logrotate.d/newrelic' do
  mode 0644
  owner 'root'
  group 'root'
  content '/srv/www/app/current/newrelic_agent.log {
        missingok
        rotate 2
        notifempty
        size 500M
        compress
        copytruncate
        }'
end

cron "newrelic_rotation" do
 hour "*"
 command "/usr/sbin/logrotate /etc/logrotate.d/newrelic"
end
