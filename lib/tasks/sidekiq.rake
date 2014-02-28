namespace :sidekiq do
  desc 'Clear failed stats'
  task :clear_failed => :environment do
    Sidekiq.redis {|c| c.del('stat:failed') }
  end

  desc 'Clear processed stats'
  task :clear_processed => :environment do
    Sidekiq.redis {|c| c.del('stat:processed') }
  end
end
