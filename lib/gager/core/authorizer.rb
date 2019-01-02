require "googleauth"
require "googleauth/stores/file_token_store"

module Gager
  module Core
    class Authorizer
      OOB_URI = "urn:ietf:wg:oauth:2.0:oob"

      attr_reader :authorization

      def initialize(client_id, client_secret, scope, user_id: "gager", token_store_file: nil)
        auth_id = Google::Auth::ClientId.new(client_id, client_secret)
        if token_store_file
          @token_store = Google::Auth::Stores::FileTokenStore.new(file: token_store_file)
        end
        @auth = Google::Auth::UserAuthorizer.new(auth_id, scope, @token_store)
        @user_id = user_id
      end

      def authorization_url
        @auth.get_authorization_url(base_url: OOB_URI)
      end

      def authorization_code=(code)
        args = {user_id: @user_id, code: code, base_url: OOB_URI}
        @authorization = if @token_store
          @auth.get_and_store_credentials_from_code(args)
        else
          @auth.get_credentials_from_code(args)
        end
      end
    end
  end
end
