# Lock version to protect against cap command being called without bundle exec
# and executing with another version
lock '3.2.1'

set :application, "Kochiku"
set :repo_url, "https://github.com/AlexRiedler/kochiku.git"
set :user, "root"

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

set :deploy_to, "/app/#{fetch(:user)}/kochiku"
set :deploy_via, :remote_cache
set :linked_dirs, %w{log}

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, File.read('.ruby-version').strip # set ruby version from the file:
# set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

# Reference Capistrano's flow diagram for help choosing hooks
# http://capistranorb.com/documentation/getting-started/flow/
before "deploy:started", "kochiku:setup"
after  "deploy:symlink:shared", "kochiku:symlinks"
before "deploy:updated", "deploy:overwrite_database_yml"

# warn if a legacy deploy deploy.custom.rb is in place
if File.exist?(File.expand_path('deploy.custom.rb', File.dirname(__FILE__)))
  warn "Kochiku has upgraded to Capistrano 3. Placing custom capistrano config in deploy.custom.rb is no longer supported. Please move Capistrano settings to config/deploy/production.rb and remove deploy.custom.rb to make this message go away."
  exit(1)
end
