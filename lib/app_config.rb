require 'telegram/bot'
require './lib/db_config'

class AppConfigurator
  def configure
    setup_database
  end

  def get_token
    ENV['TOKEN']
  end

  def get_users
    users = setup_database[:users]
  end

  private

  def setup_database
    DatabaseConnector.establish_connection
  end
end
