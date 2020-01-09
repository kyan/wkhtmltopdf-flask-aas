# frozen_string_literal: true

require 'spec_helper'

describe Pdf do
  describe '.generate' do
    let(:a_pdf) { double(:a_pdf_file) }
    let(:pdfkit) { double(PDFKit, to_pdf: a_pdf) }
    let(:options) { {} }
    let(:request) { { 'url' => content, 'options' => options } }

    context 'when sent a url' do
      let(:content) { 'http:/google.com' }

      it 'creates pdf' do
        expect(PDFKit).to receive(:new).with(content, options) { pdfkit }
        expect(described_class.generate(request)).to eq(a_pdf)
      end
    end

    context 'when sent html' do
      let(:content) { '<head></head>' }

      it 'creates pdf' do
        expect(PDFKit).to receive(:new).with(content, options) { pdfkit }
        expect(described_class.generate(request)).to eq(a_pdf)
      end
    end

    context 'when options are passed' do
      let(:options) { { page_size: 'a4' } }
      let(:content) { '<head></head>' }

      it 'are passed as a hash' do
        expect(PDFKit).to receive(:new).with(content, options) { pdfkit }
        expect(described_class.generate(request)).to eq(a_pdf)
      end
    end
  end
end
