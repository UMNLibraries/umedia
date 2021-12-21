# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "umedia"
set :repo_url, "https://github.com/UMNLibraries/umedia.git"

# Retrieve a list of tags to prompt the user for a tag to deploy,
# sorted by version and defaulting to the latest
#
# Skip the prompt by supplying a tag in env $UMEDIA_RELEASE
# Any branch name or commit hash can also be used instead of a tag
# e.g. UMEDIA_RELEASE=develop bundle exec cap staging deploy
# e.g. UMEDIA_RELEASE=v0.10.1 bundle exec cap production deploy
unless ARGV.include?('deploy:rollback')
  avail_tags = `git ls-remote --sort=version:refname --refs --tags #{repo_url} | cut -d/ -f3-`
  set :branch, (ENV['UMEDIA_RELEASE'] || ask("release tag or branch:\n #{avail_tags}", avail_tags.chomp.split("\n").last))
end

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

after 'deploy:finishing', 'deploy:clear_rails_cache'
# Restart all sidekiq instances so they can pick up the new code
namespace :deploy do
  after :finishing, :notify do
    invoke "deploy:restart_sidekiq"
  end

  task :restart_sidekiq do
    on roles(:all) do |host|
      execute "sudo systemctl restart sidekiq-0"
      execute "sudo systemctl restart sidekiq-1"
    end
  end

  task :clear_rails_cache do
    on roles(:app) do |host|
      within current_path do
        execute :bundle, 'exec rails runner "Rails.cache.clear"'
      end
    end
  end
end
