server "lib-umedia-qat-01.oit.umn.edu", user: "swadm", roles: %w{app db web}
set :deploy_to, "/swadm/var/www/app"
set :use_sudo, false
set :rails_env, "production"
set :bundle_flags, '--deployment'
set :keep_releases, 2
set :branch, 'develop'


# Don't set cron tasks for staging. Everything (indexing, solr backup, etc)
# should be done manually in the staging environment.
#
# But why?
#
# * We don't want to stress the CONTENTdm server any more than we have to.
# * We often want to see specific data tested / verified before pushing
# to production, which hap
Rake::Task["whenever:update_crontab"].clear_actions