require 'dotenv/load'
require 'json'
require 'net/http'
require 'rest-client'
require 'sequel'
require 'telegram/bot'
# Define vars, connect to DB
class AppConfigurator
  # Constants
  def token
    ENV['TELEGRAM_API_TOKEN']
  end

  def tg_api_path
    ENV['TELEGRAM_API_PATH']
  end

  def mscv
    ENV['MS_COMPUTERVISION_KEY']
  end

  def method_name
    ENV['METHOD_NAME']
  end

  def param_name
    ENV['PARAM_NAME']
  end

  # Database
  def configure
    setup_database
  end

  # Models
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
    Sequel.connect(ENV.fetch('DATABASE_CONNECTION'))
  end
end
