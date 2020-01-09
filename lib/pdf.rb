# frozen_string_literal: true

class Pdf
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def self.generate(request)
    new(request).generate
  end

  def generate
    PDFKit.new(content, options).to_pdf
  end

  private

  def content
    request['url'] || request['html']
  end

  def options
    request['options']
  end
end
