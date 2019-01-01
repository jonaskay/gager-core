RSpec.describe Gager::Core::Authorizer do
  let(:authorizer) { described_class.new("MyClientId", "MyClientSecret", "MyScope") }

  describe "#authorization_url" do
    subject { authorizer.authorization_url }

    it {
      is_expected.to eq(
        "https://accounts.google.com/o/oauth2/auth?access_type=offline" +
        "&approval_prompt=force" +
        "&client_id=MyClientId" +
        "&include_granted_scopes=true" +
        "&redirect_uri=urn:ietf:wg:oauth:2.0:oob" +
        "&response_type=code" +
        "&scope=MyScope"
      )
    }
  end
end
