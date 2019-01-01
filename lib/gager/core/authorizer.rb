require "googleauth"

module Gager
  module Core
    class Authorizer
      OOB_URI = "urn:ietf:wg:oauth:2.0:oob"

      def initialize(client_id:, client_secret:, scope:, token_store: nil)
        auth_id = Google::Auth::ClientId.new(client_id, client_secret)
        @auth   = Google::Auth::UserAuthorizer.new(auth_id, scope, token_store)
      end

      def authorization_url
        @auth.get_authorization_url(base_url: OOB_URI)
      end
    end
  end
end
