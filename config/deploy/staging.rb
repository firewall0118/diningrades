set :branch, :dev

namespace :deploy do
  # ....
  # @example
  #   bundle exec cap uat deploy:invoke task=users:update_defaults
  desc 'Invoke rake task on the server'
  task :invoke do
    fail 'no task provided' unless ENV['task']

    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, ENV['task']
        end
      end
    end
  end

end