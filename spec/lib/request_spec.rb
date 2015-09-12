require 'spec_helper'

describe WebServer::Request do
  describe '#initialize' do 
    let(:request_content) do
      <<-CONTENT
GET /?param1=one HTTP/1.1
Host: localhost
Content-Length: 40

This is the body.
With multiple lines...
      CONTENT
    end
    let(:io) { StringIO.new(request_content) }
    let(:request) { WebServer::Request.new(io) }

    it 'parses the method' do
      expect(request.http_method).to eq 'GET'
    end

    it 'parses the uri' do
      expect(request.uri).to eq '/'
    end

    it 'parses the http version' do
      expect(request.version).to eq 'HTTP/1.1'
    end

    it 'parses the headers' do
      expect(request.headers['HOST']).to eq 'localhost'
    end

    it 'creates ENV type header names' do
      expect(request.headers['CONTENT_LENGTH']).to eq '40'
    end

    it 'parses the body' do
      expect(request.body).to eq "This is the body.\nWith multiple lines..."
    end

    it 'parses the query string' do
      expect(request.params['param1']).to eq 'one'
    end
  end
end
