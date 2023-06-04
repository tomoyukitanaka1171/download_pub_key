require 'logger'
require 'net/http'

class Task
  BASE_URL = 'https://github.com'
  USER_NAME = 'tomoyukitanaka1171'

  def initialize
    @uri = URI.parse("#{BASE_URL}/#{USER_NAME}.keys")
    @logger = Logger.new(STDOUT)
    @logger.formatter = ::Logger::Formatter.new
  end

  def download
    request = Net::HTTP::Get.new(@uri)
    request['Accept-Charset'] = 'utf-8'

    begin
      res = Net::HTTP.start(@uri.host, @uri.port, use_ssl: true) do |http|
        http.request(request)
      end
      if res.is_a?(Net::HTTPSuccess)
        filename = 'authorized_key.pub'
        @logger.info("DOWNLOADED: #{filename}")
        File.write(filename, res.body)
      else
        @logger.error('################')
        @logger.error(res)
        @logger.error('################')
      end
    rescue => e
      @logger.error('################')
      @logger.error(e)
      @logger.error('################')
    end
  end

end

Task.new.download

