require 'sequel'
require 'dotenv/load'
require 'rufus-scheduler'
require 'telegram/bot'
require './lib/app_config'

token = ENV['TOKEN']

scheduler = Rufus::Scheduler.new

db = Sequel.connect(ENV.fetch('DATABASE_CONNECTION'))
users = db[:users]
tasks = db[:tasks]

bot = Telegram::Bot::Client.new(token)

scheduler.every '1m', first: :now do
  users.each do |user|
    random_task = tasks.where(id: rand(1..tasks.count)).first[:description]
    bot.api.send_message(chat_id: user[:chat_id], text: "Сьогоднішнє завдання — зробити фото, на якому буде #{random_task}")
  end
end
