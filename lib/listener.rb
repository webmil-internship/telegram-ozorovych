class Listener
  attr_accessor :tg_token, :tg_api_path, :mscv_key, :bot, :message, :tasks, :sender, :rating

  def initialize
    config = AppConfigurator.new
    config.configure
    @tg_token = config.token
    @tg_api_path = config.tg_api_path
    @mscv_key = config.mscv
    @bot = Telegram::Bot::Client
    @message = message
    @sender = Sender.new
    @rating = Ratinger.new
  end

  def run
    sender.run
    bot.run(tg_token) do |bot|
      bot.listen do |message|
        user = User.find(chat_id: message.from.id)
        responder = Responder.new(bot, message)
        # responder.send_error if user.nil?
        if message.photo.any?
          photo = message.photo.last
          parser = Parser.new
          parser.run(photo, user)
        elsif !message.document.nil?
          responder.file_error
        else
          case message.text
          when '/start'
            if user.nil?
              responder.start_game
              User.create(user_name: "#{message.from.first_name} #{message.from.last_name}",
                          chat_id: message.chat.id)
            else
              responder.help
            end
          when '/rating'
            # bot.api.send_message(
            #  chat_id: message.chat.id,
            #  text: rating.show
            # )
            rating.show
          when '/stop'
            responder.stop_game
            user.delete
          else
            responder.help
          end
        end
      end
    end
  end
end
