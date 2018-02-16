require_relative 'app_config'
require_relative 'responder'
require_relative 'sender'
class Listener
  attr_accessor :tg_token, :tg_api_path, :mscv_key, :bot, :users, :tasks,
                :method_name, :param_name, :sender

def initialize
  config = AppConfigurator.new
  config.configure

  sender = Sender.new

  @tg_token = config.token
  @tg_api_path = config.tg_api_path

  @mscv_key = config.mscv
  @method_name = config.method_name
  @param_name = config.param_name

  @bot = Telegram::Bot::Client
  @users = config.users
  @tasks = config.tasks
end

def run
  bot.run(tg_token) do |bot|
    bot.listen do |message|
      @bot = bot
      @message = message
      responder = Responder.new(bot, message)

      if message.photo.any?
        photo = message.photo.last
        get_file_url = "#{tg_api_path}/bot#{tg_token}/#{method_name}?#{param_name}=#{photo.file_id}"
        json_response = RestClient.get(get_file_url).body
        response = JSON.parse(json_response)
        file_path = response.dig("result", "file_path")
        file_url = "#{tg_api_path}/file/bot#{tg_token}/#{file_path}"
        uri = URI('https://westcentralus.api.cognitive.microsoft.com/vision/v1.0/analyze')
        uri.query = URI.encode_www_form({
            'visualFeatures' => 'Tags',
            'language' => 'en'
        })
        request = Net::HTTP::Post.new(uri.request_uri)
        request['Content-Type'] = 'application/json'
        request['Ocp-Apim-Subscription-Key'] = mscv_key
        request.body = "{\"url\": \"#{file_url}\"}"

        response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
          http.request(request)
        end
        json = JSON.parse(response.body)
        tags = json['tags']
        tags.each do |tag|
          # TODO: compare with task tag
          # TODO: insert user_id, task_id and confidence into DB
          puts "Тег: #{tag['name']}, влучність: #{tag['confidence']}"
        end
      elsif !message.document.nil?
        responder.file_error
      else
        case message.text
        when '/start'
          users.insert(user_id: message.from.id, chat_id: message.chat.id)
          responder.start_game
        when '/rating'
          responder.rating
        when '/stop'
          users.where(user_id: message.from.id).delete
          responder.stop_game
        else
          responder.help
        end
      end
    end
  end
end
end
