# config/unicorn.rb
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)

root = "/var/www/casinoapp"
working_directory "#{root}/current"
pid "#{root}/shared/tmp/pids/unicorn.pid"
stderr_path "/#{root}/shared/log/unicorn.log"
stdout_path "#{root}/shared/log/unicorn.log"

# listen "#{root}/current/tmp/sockets/casino.sock", :backlog => 64
listen "#{root}/shared/sockets/casino.sock", :backlog => 64

# listen 3000 # listen to port 3000 on all TCP interfaces
# listen "127.0.0.1:3000"  # listen to port 3000 on the loopback interface
# listen "/path/to/.unicorn.sock" # listen on the given Unix domain socket
# listen "[::1]:3000" # listen to port 3000 on the IPv6 loopback interface


timeout 15
preload_app true

before_fork do |server, worker|
  # Signal.trap 'TERM' do
  #   puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
  #   Process.kill 'QUIT', Process.pid
  # end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!


  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
