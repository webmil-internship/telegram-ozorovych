require 'sequel'
require 'dotenv/load'

class DatabaseConnector
  class << self
    def establish_connection
      db = Sequel.connect(ENV.fetch('DATABASE_CONNECTION'))
    end
  end
end
