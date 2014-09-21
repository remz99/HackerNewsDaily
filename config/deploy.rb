# load the capistrano configs
CAP_CONFIG = YAML.load_file(File.expand_path('../secrets.yml', __FILE__))["production"]["capistrano"]

# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'HackerNewsDaily'
set :repo_url, 'git@github.com:remz99/HackerNewsDaily.git'
set :deploy_to, CAP_CONFIG[:deploy_to]

set :sidekiq_default_hooks,  true
set :sidekiq_pid, File.join(shared_path, 'tmp', 'pids', 'sidekiq.pid')
set :sidekiq_log, File.join(shared_path, 'log', 'sidekiq.log')
set :sidekiq_logfile, File.join(shared_path, 'log', 'sidekiq.log')
set :sidekiq_timeout, 10
set :sidekiq_processes, 1
set :sidekiq_concurrency, 3

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# issue with sidekiq if true
set :pty, false

# Default value for :linked_files is []
set :linked_files, %w{config/secrets.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for keep_releases is 5
set :keep_releases, 3

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end

