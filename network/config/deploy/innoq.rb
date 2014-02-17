@capistrano_history ||= {}

# main details
servername = "helloworld.innoq.com"
role :web, servername
role :app, servername
role :db,  servername, :primary => true

username = Capistrano::CLI.ui.ask("Please enter a ssh username for helloworld.innoq.com  [#{@capistrano_history['last_user']}]: ")
username = @capistrano_history['last_user'] if username == ""
@capistrano_history['last_user'] = username

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_to, "/srv/helloworld"
set :deploy_via, :remote_cache
set :user, username
set :use_sudo, false

save_history if defined?(save_history)