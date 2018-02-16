# All stuff for responding to users should be here
class Responder
  attr_accessor :bot, :message
  def initialize(bot, message)
    @bot = bot
    @message = message
  end

  def start_game
    bot.api.send_message(
      chat_id: message.chat.id,
      text: "Привіт, #{message.from.first_name}. Давай зіграємо в гру.\nВведи /help, щоб ознайомитися із правилами"
    )
  end

  def help
    bot.api.send_message(
      chat_id: message.chat.id,
      text: 'Тут буде текст, який пояснюватиме правила гри і показуватиме всі доступні команди'
    )
  end

  def rating
    bot.api.send_message(
      chat_id: message.chat.id,
      text: 'Тут буде рейтинг'
    )
  end

  def stop_game
    bot.api.send_message(
      chat_id: message.chat.id,
      text: 'Ти виходиш з гри. Щоб повернутися — знову введи /start. Але зауваж — весь твій прогрес буде втрачено...'
    )
  end

  def file_error
    bot.api.send_message(
      chat_id: message.chat.id,
      text: 'Не підходить. Будь ласка надішліть файл у форматі jpg'
    )
  end
end
