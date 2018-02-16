require 'rufus-scheduler'
require_relative 'app_config'

class Sender
  attr_accessor :tg_token, :scheduler, :bot, :users, :tasks

  def initialize
    @scheduler = Rufus::Scheduler.new
    config = AppConfigurator.new
    config.configure

    @tg_token = config.token
    @bot = Telegram::Bot::Client
    @users = config.users
    @tasks = config.tasks
    @shedule = config.shedule
  end

  def run
    bot.run(tg_token) do |bot|
    scheduler.every '10m', first: :now do
      random_task = tasks.where(id: rand(1..tasks.count)).first[:description]

      users.each do |user|
        bot.api.send_message(chat_id: user[:chat_id], text: "Сьогоднішнє завдання — зробити фото, на якому буде #{random_task}")
      end
    end
  end
end
end
