class Pathfinder
  def initialize(file_id = '')
    @tg_token = ENV['TELEGRAM_API_TOKEN']
    @tg_api_path = ENV['TELEGRAM_API_PATH']
    @file_id = file_id
  end

  def call
    return if file_id.empty?
    responce = JSON.parse(RestClient.get(get_file_url).body)
    return responce unless responce['ok']
    file_url(responce.dig('result', 'file_path'))
  end

  private
    attr_accessor :tg_token, :file_id

    def get_file_url
      "#{tg_api_path}/bot#{tg_token}/getFile?file_id=#{file_id}"
    end

    def file_url(file_path)
      "#{tg_api_path}/file/bot#{tg_token}/#{file_path}"
    end
end
