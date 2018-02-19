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
        user = User.find(user_id: message.from.id)
        responder = Responder.new(bot, message)
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
              User.create(user_id: message.from.id, chat_id: message.chat.id)
            else
              responder.help
            end
          when '/rating'
            rating.today
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
