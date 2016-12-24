web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -r ./app/workers/syncronizer.rb -c 3
