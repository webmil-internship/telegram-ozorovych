class Responder
  HELPMSG = 'Доступні команди:
  /start - початок гри
  /stop - вихід з гри
  /rating - вивід рейтинга
  /help - цей текст'
  STOPMSG = 'Ти виходиш з гри. Щоб повернутися — знову введи /start. Але зауваж — весь твій прогрес буде втрачено...'
  PHOTOERRORMSG = 'Не підходить. Будь ласка надішліть файл у форматі jpg'
  SENDERRORMSG = 'Ви уже надсилали фото, дочекайтесь наступного раунду гри'
  CONTENTERRORMSG = 'На жаль, на фото немає необхідного предмету. Спробуй ще'

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
      text: HELPMSG
    )
  end

  def rating
    bot.api.send_message(
      chat_id: message.chat.id,
      text: Ratinger.new.show
    )
  end

  def stop_game
    bot.api.send_message(
      chat_id: message.chat.id,
      text: STOPMSG
    )
  end

  def file_error
    bot.api.send_message(
      chat_id: message.chat.id,
      text: PHOTOERRORMSG
    )
  end

  def send_error
    bot.api.send_message(
      chat_id: message.chat.id,
      text: SENDERRORMSG
    )
  end

  def wrong_photo
    bot.api.send_message(
      chat_id: message.chat.id,
      text: CONTENTERRORMSG
    )
  end
end
