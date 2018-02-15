require './lib/app_config'
require './lib/sender'

config = AppConfigurator.new
config.configure

token = config.token
mscv_key = config.mscv
tg_api_path = config.tg_api_path
method_name = config.method_name
param_name = config.param_name

bot = Telegram::Bot::Client
users = config.users
tasks = config.tasks

bot.run(token) do |bot|
  bot.listen do |message|
    if message.photo.any?
      photo = message.photo.last
      get_file_url = "#{tg_api_path}/bot#{token}/#{method_name}?#{param_name}=#{photo.file_id}"
      json_response = RestClient.get(get_file_url).body
      response = JSON.parse(json_response)
      file_path = response.dig("result", "file_path")
      file_url = "#{tg_api_path}/file/bot#{token}/#{file_path}"
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
      bot.api.send_message(
          chat_id: message.chat.id,
          text: 'Не підходить. Будь ласка надішліть файл у форматі jpg'
      )
    else
      case message.text
      when '/start'
        # TODO: Check if users already in game, if not - add to DB and send it:
        users.insert(user_id: message.from.id, chat_id: message.chat.id)
        bot.api.send_message(
          chat_id: message.chat.id,
          text: "Привіт, #{message.from.first_name}. Давай зіграємо в гру.\nВведи /help, щоб ознайомитися із правилами"
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
      when '/stop'
        users.where(user_id: message.from.id).delete
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
