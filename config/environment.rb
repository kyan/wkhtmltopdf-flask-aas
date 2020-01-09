require 'bundler'
Bundler.require

# get the path of the root of the app
APP_ROOT = File.expand_path("..", __dir__)

require File.join(APP_ROOT, 'app', 'app')

Dir.glob(File.join(APP_ROOT, 'lib', '*.rb')).each { |f| require f }

class App < Sinatra::Base
  configure :production, :development do
    enable :logging
  end
end

PDFKit.configure do |config|
  config.verbose = false
  config.default_options = {
    page_size: 'A4'
  }
end
