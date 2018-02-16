require_relative 'app_config'

class Parser
  attr_accessor :message
  def initialize(message)
    config = AppConfigurator.new
    config.configure

    @mscv_key = config.mscv
    @method_name = config.method_name
    @param_name = config.param_name

    @message = message
    @photo = message.photo.last
  end

  def send_photo
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
  end

  private
  def file_url
    get_file_url = "#{tg_api_path}/bot#{tg_token}/#{method_name}?#{param_name}=#{photo.file_id}"
    json_response = RestClient.get(get_file_url).body
    response = JSON.parse(json_response)
    file_path = response.dig("result", "file_path")
    file_url = "#{tg_api_path}/file/bot#{tg_token}/#{file_path}"
  end
end
