# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "umedia"
set :repo_url, "https://github.com/UMNLibraries/umedia.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

desc "Run this before the first deploy to an OIT VM to clear out stuff left around by Ansible Solr"
task :reset_current_dir do
  on roles(:app) do
    execute "rm -rf #{current_path}"
  end
end

set :passenger_restart_with_touch, true

append :linked_dirs, "log"
append :linked_dirs, "tmp/pids"


# Stop all sidekiq instances so they can pick up the new code
# systemd is responsible for restarting stopped sidekiq jobs
namespace :deploy do
  after :finishing, :notify do
    invoke "deploy:stop_sidekiq"
  end
  task :stop_sidekiq do
    on roles(:all) do |host|
      (0..2).map do |pid|
        execute "cd '#{release_path}'; bundle exec sidekiqctl stop ./tmp/pids/sidekiq-#{pid}.pid RAILS_ENV=production"
      end
    end
  end
end