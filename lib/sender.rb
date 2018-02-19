class Sender
  attr_accessor :tg_token, :scheduler, :bot, :task

  def initialize
    @scheduler = Rufus::Scheduler.new
    config = AppConfigurator.new
    config.configure
    @tg_token = config.token
    @task = Tasksheduler.new
    @bot = Telegram::Bot::Client
  end

  def run
    bot.run(tg_token) do |bot|
      scheduler.every '10m', first: :now do
        User.each do |user|
          bot.api.send_message(chat_id: user[:chat_id],
          text: "Сьогоднішнє завдання — зробити фото, на якому буде #{task.description}")
        end
      end
    end
  end
end
