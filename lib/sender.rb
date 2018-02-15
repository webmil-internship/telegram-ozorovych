require 'rufus-scheduler'
require './lib/app_config'

token = ENV['TELEGRAM_API_TOKEN']

scheduler = Rufus::Scheduler.new

db = Sequel.connect(ENV.fetch('DATABASE_CONNECTION'))
bot = Telegram::Bot::Client
users = db[:users]
tasks = db[:tasks]

bot.run(token) do |bot|
  scheduler.every '10m', first: :now do
    users.each do |user|
      random_task = tasks.where(id: rand(1..tasks.count)).first[:description]
      bot.api.send_message(chat_id: user[:chat_id], text: "Сьогоднішнє завдання — зробити фото, на якому буде #{random_task}")
    end
  end
end
