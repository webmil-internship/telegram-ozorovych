class Sender
  attr_accessor :tg_token, :scheduler, :bot, :task

  def initialize
    @scheduler = Rufus::Scheduler.new
    @tg_token = ENV['TELEGRAM_API_TOKEN']
    @task = Tasksheduler.new
    @bot = Telegram::Bot::Client
  end

  def run
    bot.run(tg_token) do |bot|
      scheduler.every '10m', first: :now do
      # scheduler.cron '00 08 * * *' do
        User.each do |user|
          bot.api.send_message(chat_id: user[:chat_id],
          text: "Сьогоднішнє завдання — зробити фото, на якому буде #{task.description}")
        end
      end
    end
  end
end
