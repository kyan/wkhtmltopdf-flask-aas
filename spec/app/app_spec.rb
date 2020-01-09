# frozen_string_literal: true

require 'spec_helper'

describe App do
  describe 'POST /pdf' do
    let(:pdf) { 'A pdf' }

    before do
      allow(Pdf).to receive(:generate) { pdf }
      post '/pdf', request
    end

    context 'status codes' do
      subject { last_response.status }

      context 'with valid html request' do
        let(:request) { { html: '<head></head>', options: {} }.to_json }

        it { is_expected.to eq(200) }
      end

      context 'with valid url request' do
        let(:request) { { url: 'http://google.com', options: {} }.to_json }

        it { is_expected.to eq(200) }
      end

      context 'with invalid request' do
        let(:request) { {}.to_json }

        it { is_expected.to eq(422) }
      end
    end

    context 'when sent a url' do
      let(:request) { { url: 'http://google.com', options: {} }.to_json }

      subject { last_response.body }

      it { is_expected.to eq(pdf) }
    end

    context 'when sent html' do
      let(:request) { { html: '<head></head>', options: {} }.to_json }

      subject { last_response.body }

      it { is_expected.to eq(pdf) }
    end

    context 'when not sent content' do
      let(:request) { { options: {} }.to_json }

      subject { last_response.body }

      it { is_expected.to eq('No data supplied to generate pdf') }
    end
  end
end
