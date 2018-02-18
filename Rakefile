require 'dotenv/load'
require 'sequel'
# Sequel.extension :migration
# Sequel.extension :seed

db = Sequel.connect(ENV.fetch('DATABASE_CONNECTION'))
namespace :db do
  desc 'Run migrations'
  task :migrate, [:version] do |t, args|
    Sequel.extension :migration
    puts 'Migrating to latest'
    Sequel::Migrator.run(db, 'db/migrations')
  end

#  desc 'Perform insert seed'
#  task :seed do
#    Dir[File.dirname(__FILE__) + '/models/*.rb'].each { |file| require file }
#    puts 'Seeding data'
#    Sequel::Seeder.apply(db, 'db/seeds')
#  end
end
