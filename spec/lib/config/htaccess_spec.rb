require 'spec_helper'
require 'test_construct/rspec_integration'
require 'base64'

describe WebServer::Htaccess do
  let(:htpwd_file_name) { '.htpwd_file_name' }
  let(:auth_name) { "This is the auth_name" }
  let(:user_name) { 'some_user' }
  let(:all_users) { [user_name, 'other_one', 'other_two']}
  let(:htaccess_file_content) do
    <<-FILE_CONTENT
AuthUserFile #{htpwd_file_name}
AuthType Basic
AuthName "#{auth_name}"
    FILE_CONTENT
  end

  let(:valid_user_content) do
    htaccess_file_content + <<-FILE_CONTENT
Require valid-user
    FILE_CONTENT
  end

  let(:user_content) do
    htaccess_file_content + <<-FILE_CONTENT
Require #{user_name}
    FILE_CONTENT
  end

  let(:htaccess_valid_user) { WebServer::Htaccess.new(valid_user_content) }
  let(:htaccess_user) { WebServer::Htaccess.new(user_content) }

  let(:htpasswd_content) do
    all_users.map do |user_name| 
      "#{user_name}:{SHA}#{Digest::SHA1.base64digest('password')}"
    end.join("\n")
  end

  def stub_htpwd_file
    within_construct do |construct|
      construct.directory '.' do |directory|
        directory.file htpwd_file_name, htpasswd_content

        yield
      end
    end
  end

  def encrypted_string(user = user_name)
    Base64.encode64 "#{user}:password"
  end

  describe '#auth_user_file' do
    it 'returns the AuthUserFile string' do
      expect(htaccess_valid_user.auth_user_file).to eq htpwd_file_name
    end
  end

  describe '#auth_type' do
    it 'returns "Basic"' do
      expect(htaccess_valid_user.auth_type).to eq 'Basic'
    end
  end

  describe '#auth_name' do
    it 'returns the AuthName string' do
      expect(htaccess_user.auth_name).to eq auth_name
    end
  end

  describe '#require_user' do
    it 'returns the Require string' do
      expect(htaccess_user.require_user).to eq user_name
    end
  end

  describe '#authorized?' do
    context 'for valid-user' do
      context 'with valid credentials' do
        it 'returns true' do
          stub_htpwd_file do
            expect(htaccess_valid_user.authorized?(encrypted_string)).to be_true
          end
        end
      end

      context 'with invalid credentials' do
        it 'returns false' do
          stub_htpwd_file do
            expect(htaccess_valid_user.authorized?(encrypted_string('bad user'))).not_to be_nil
            expect(htaccess_valid_user.authorized?(encrypted_string('bad user'))).to be_false
          end
        end
      end
    end

    context 'for specific user' do
      context 'with valid credentials' do
        it 'returns true' do
          stub_htpwd_file do
            expect(htaccess_user.authorized?(encrypted_string)).to be_true
          end
        end
      end

      context 'with invalid credentials' do
        it 'returns false' do
          stub_htpwd_file do
            expect(htaccess_user.authorized?(encrypted_string('bad user'))).not_to be_nil
            expect(htaccess_user.authorized?(encrypted_string('bad user'))).to be_false
          end
        end
      end
    end
  end

  describe '#users' do
    let(:result) { htaccess_valid_user.users }

    it 'returns an array of users from the htpasswd file' do
      stub_htpwd_file do
        expect(result).to be_kind_of Array
        expect(result).to include *all_users
      end
    end
  end
end