class Listener
  attr_reader :tg_token, :tg_api_path, :mscv_key
  attr_accessor :bot, :message

  def initialize
    @tg_token = ENV['TELEGRAM_API_TOKEN']
    @tg_api_path = ENV['TELEGRAM_API_PATH']
    @mscv_key = ENV['MS_COMPUTERVISION_KEY']
    @bot = Telegram::Bot::Client
    @message = message
  end

  def run
    Sender.new.run
    bot.run(tg_token) do |bot|
      bot.listen do |message|
        user = User.find(chat_id: message.from.id)
        responder = Responder.new(bot, message)
        # TODO: responder.send_error if user.nil?
        if message.photo.any?
          photo = message.photo.last
          Parser.new.run(photo, user)
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
            responder.rating
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
