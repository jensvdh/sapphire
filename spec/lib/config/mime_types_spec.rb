require 'spec_helper'

describe WebServer::MimeTypes do
  let(:mime_content) do
    <<-FILE_CONTENT
# This is a comment followed by a blank line

image/png     png
image/jpeg    jpeg jpg jpe
    FILE_CONTENT
  end
  let(:mime_types) { WebServer::MimeTypes.new(mime_content) }

  describe '#for_extension' do
    it 'returns the default mime type for unknown extensions' do
      expect(mime_types.for_extension('random')).to eq 'text/plain'
    end

    it 'returns the correct mime type (single entry)' do
      expect(mime_types.for_extension('png')).to eq 'image/png'
    end

    it 'returns the correct mime type (multiple entry)' do
      expect(mime_types.for_extension('jpeg')).to eq 'image/jpeg'
      expect(mime_types.for_extension('jpg')).to eq 'image/jpeg'
      expect(mime_types.for_extension('jpe')).to eq 'image/jpeg'
    end
  end
end
