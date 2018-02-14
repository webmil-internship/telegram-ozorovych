require './lib/app_config'

config = AppConfigurator.new
config.configure

token = config.get_token
users = config.get_users

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      users.insert(user_id: message.from.id, chat_id: message.chat.id)
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "Привіт, #{message.from.first_name}. Давай зіграємо в гру.\nВведи /rules , щоб ознайомитися із правилами.\n#{message.from.id}\n#{message.chat.id}"
    )
    when '/rules'
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Тут буде текст, який пояснюватиме правила гри'
    )
    when '/rating'
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Тут буде рейтинг'
    )
    when '/stop'
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Ти виходиш з гри. Щоб повернутися — знову введи /start. Але зауваж — весь твій прогрес буде втрачено...'
    )
    else
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Введіть команду або ознайомтесь з правилами, ввівши команду /rules'
        )
    end
  end
when '/ratistop    bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Тут буде рейтинг'
    )enТи виходиш з гри. Щоб повернутися — знову введи /start. Але зауваж — весь твій прогрес буде втрачено...d
