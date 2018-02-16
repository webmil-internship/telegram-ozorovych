require_relative './lib/app_config'
require_relative './lib/listener'

listener = Listener.new
listener.run
