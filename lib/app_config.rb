require 'telegram/bot'
require './lib/db_config'

class AppConfigurator
  def configure
    setup_database
  end

  def token
    ENV['TOKEN']
  end

  def users
    setup_database[:users]
  end

  def tasks
    setup_database[:tasks]
  end

  def ratings
    setup_database[:ratings]
  end

  private

  def setup_database
    DatabaseConnector.establish_connection
  end
end
