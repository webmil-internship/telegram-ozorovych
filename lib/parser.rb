class Parser
  attr_accessor :message, :photo, :uri, :mscv_key, :tg_api_path, :tg_token, :task, :user
  def initialize
    @tg_token = ENV['TELEGRAM_API_TOKEN']
    @tg_api_path = ENV['TELEGRAM_API_PATH']
    @mscv_key = ENV['MS_COMPUTERVISION_KEY']
    @uri = URI('https://westcentralus.api.cognitive.microsoft.com/vision/v1.0/analyze')
    @message = message
    @photo = photo
    @user = user
  end

  def run(photo, user)
    get_file_url = "#{tg_api_path}/bot#{tg_token}/getFile?file_id=#{photo.file_id}"
    json_response = RestClient.get(get_file_url).body
    response = JSON.parse(json_response)
    file_path = response.dig('result', 'file_path')
    file_url = "#{tg_api_path}/file/bot#{tg_token}/#{file_path}"
    uri.query = URI.encode_www_form({
        'visualFeatures' => 'Tags',
        'language' => 'en'
    })
    request = Net::HTTP::Post.new(uri.request_uri)
    request['Content-Type'] = 'application/json'
    request['Ocp-Apim-Subscription-Key'] = mscv_key
    request.body = "{\"url\": \"#{file_url}\"}"

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
    json = JSON.parse(response.body)
    tags = json['tags']
    tags.each do |tag|
      task = Tasksheduler.new
      if tag['name'] == task.tag
        Rating.create(user_id: user[:id], task_id: task.id, propability: tag['confidence'])
      end
    end
  end
end
