require 'spec_helper'
require 'test_construct/rspec_integration'

describe WebServer::Resource do
  let(:mimes) { double(WebServer::MimeTypes) }
  let(:access_file) { '.test_access_file' }
  let(:test_doc_root) { '/doc_root' }
  let(:access_file_path) { "#{test_doc_root}/protected/#{access_file}" }

  def conf_double(options={})
    double(WebServer::HttpdConf, {
      document_root: test_doc_root,
      directory_index: 'index.html'
    }.merge(options))
  end

  def request_double(options={})
    double(WebServer::Request, {
      http_method: options.fetch(:method, 'GET'),
      uri: options.fetch(:uri, '/')
    })
  end

  def protect_directory(directory_path)
    within_construct do |construct|
      construct.directory directory_path do |directory|
        directory.file access_file, ''

        yield
      end
    end
  end

  describe '#resolve' do
    context 'for an unaliased path' do
      let(:conf) do 
        object = conf_double
        object.stub(:aliases).and_return []
        object.stub(:script_aliases).and_return []
        object
      end
      let(:request) { request_double(uri: '/a/resource') }

      it 'should return the absolute path to the file' do
        expected_path = "#{conf.document_root}#{request.uri}/#{conf.directory_index}"
        expect(WebServer::Resource.new(request, conf, mimes).resolve).to eq expected_path
      end
    end

    context 'for a script aliased path' do
      let(:conf) do
        object = conf_double
        object.stub(:aliases).and_return []
        object.stub(:script_aliases).and_return ['/ss/ss']
        object.stub(:script_alias_path).and_return '/tt/tt/tt'
        object
      end
      let(:request) { request_double(uri: '/ss/ss/resource.php') }

      it 'should return the absolute path to the file' do
        expected_path = '/tt/tt/tt/resource.php'
        expect(WebServer::Resource.new(request, conf, mimes).resolve).to eq expected_path
      end
    end

    context 'for an aliased path' do
      let(:conf) do 
        object = conf_double
        object.stub(:aliases).and_return ['/aa/aa']
        object.stub(:alias_path).and_return('/bb/bb/bb')
        object
      end
      let(:request) { request_double(uri: '/aa/aa/resource') }

      it 'should return the absolute path to the file' do
        expected_path = '/bb/bb/bb/resource/index.html'
        expect(WebServer::Resource.new(request, conf, mimes).resolve).to eq expected_path
      end
    end
  end

  describe '#script_aliased?' do
    context 'for a script aliased path' do
      let(:conf) { conf_double(script_aliases: ['/ss/ss'], script_alias_path: '/tt/tt/tt') }
      let(:request) { request_double(uri: '/ss/ss/resource') }

      it 'returns true' do
        expect(WebServer::Resource.new(request, conf, mimes).script_aliased?).to be_true
      end
    end

    context 'for a non script aliased path' do
      let(:conf) { conf_double(script_aliases: []) }
      let(:request) { request_double(uri: '/a/resource') }

      it 'returns false for a non script aliased path' do
        expect(WebServer::Resource.new(request, conf, mimes).script_aliased?).to eq false
      end
    end
  end

  describe '#protected?' do
    let(:conf) { conf_double(access_file_name: access_file, aliases: [], script_aliases: []) }

    context 'when resource is in protected directory' do
      let(:protected_directory) { `pwd` }
      let(:request) { request_double(uri: "#{protected_directory}/resource.html") }

      it 'returns true' do
        protect_directory protected_directory do
          expect(WebServer::Resource.new(request, conf, mimes).protected?).to be_true
        end
      end
    end
 
    context 'when unprotected directory' do
      let(:request) { request_double(uri: '/a/resource') }

      it 'returns false' do
        expect(WebServer::Resource.new(request, conf, mimes).protected?).to eq false
      end
    end
  end
end
