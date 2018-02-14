require './lib/app_config'

config = AppConfigurator.new
config.configure

token = config.token
users = config.users
tasks = config.tasks

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    if message.photo.any?
      puts 'Фото отримано'
      # TODO: some stuff
    else
      case message.text
      when '/start'
        users.insert(user_id: message.from.id, chat_id: message.chat.id)
        bot.api.send_message(
          chat_id: message.chat.id,
          text: "Привіт, #{message.from.first_name}. Давай зіграємо в гру.\nВведи /rules , щоб ознайомитися із правилами.\n#{message.from.id}\n#{message.chat.id}"
      )
      when '/help'
        bot.api.send_message(
          chat_id: message.chat.id,
          text: 'Тут буде текст, який пояснюватиме правила гри і показуватиме всі доступні команди'
      )
      when '/rating'
        bot.api.send_message(
          chat_id: message.chat.id,
          text: 'Тут буде рейтинг'
      )
      when '/show' # Just for development needs, delete before release
        bot.api.send_message(
          chat_id: message.chat.id,
          text: "#{tasks.all}"
      ) 
      puts tasks.all 
      when '/stop'
        # TODO: Add method to remove all associated data from tables
        bot.api.send_message(
          chat_id: message.chat.id,
          text: 'Ти виходиш з гри. Щоб повернутися — знову введи /start. Але зауваж — весь твій прогрес буде втрачено...'
      )
      else
        bot.api.send_message(
          chat_id: message.chat.id,
          text: 'Введіть команду або ознайомтесь з правилами, ввівши команду /help'
          )
      end
    end
  end
end
