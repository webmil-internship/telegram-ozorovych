require 'dotenv/load'
require 'json'
require 'net/http'
require 'rest-client'
require 'rufus-scheduler'
require 'sequel'
require 'telegram/bot'
require './db/db_setup'
require './models/rating'
require './models/schedule'
require './models/task'
require './models/user'
require_relative 'parser'
require_relative 'pathfinder'
require_relative 'responder'
require_relative 'sender'
require_relative 'tasksheduler'

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
  def user
    User.find(user_id: message.from.id)
  end

  def ratings
    setup_database[:ratings]
  end

  #def schedule
  #  setup_database[:schedule]
  #end

  private

  def setup_database
    Sequel.connect(ENV.fetch('DATABASE_CONNECTION'))
    # Sequel::Model.raise_on_save_failure = false
  end
end
