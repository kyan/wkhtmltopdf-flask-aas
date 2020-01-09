# frozen_string_literal: true

class App < Sinatra::Base
  before do
    request.body.rewind
    j = request.body.read
    @request_data = JSON.parse(j)
  end

  post '/pdf' do
    if @request_data.key?('html') || @request_data.key?('url')
      content_type 'application/pdf'
      Pdf.generate(@request_data)
    else
      logger.error 'No data supplied to generate pdf'
      status 422
      body 'No data supplied to generate pdf'
    end
  end
end
