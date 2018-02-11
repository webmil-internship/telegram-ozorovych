require 'telegram/bot'
require './variables'

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "Привіт, #{message.from.first_name}. Давай зіграємо в гру.\nВведи /rules , щоб ознайомитися із правилами"
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
    else
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Введіть команду або ознайомтесь з правилами, ввівши команду /rules'
        )
    end
  end
end
