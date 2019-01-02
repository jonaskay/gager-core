RSpec.shared_examples "generate authorization" do
  context "when code is valid" do
    let(:code) { "MyCode" }

    it "generates authorization" do
      expect { subject }.to change { authorizer.authorization }
    end
  end

  context "when code is invalid" do
    let(:code) { "invalid" }

    it "raises an error" do
      expect { subject }.to raise_error("Authorization failed.")
    end
  end
end

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

  describe "#authorization_code=" do
    before {
      stub_request(:post, "https://oauth2.googleapis.com/token").with(
        body: {
          "client_id" => "MyClientId",
          "client_secret" => "MyClientSecret",
          "code" => "MyCode",
          "grant_type" => "authorization_code",
          "redirect_uri" => "urn:ietf:wg:oauth:2.0:oob"
        }
      ).to_return(
        status: 200,
        body: '{"access_token": "12345"}',
        headers: {
          "Content-Type" => "application/json; charset=utf-8"
        }
      )
    }

    before {
      stub_request(:post, "https://oauth2.googleapis.com/token").with(
        body: {
          "client_id" => "MyClientId",
          "client_secret" => "MyClientSecret",
          "code" => "invalid",
          "grant_type" => "authorization_code",
          "redirect_uri" => "urn:ietf:wg:oauth:2.0:oob"
        }
      ).to_return(
        status: 400,
        body: "",
        headers: {}
      )
    }

    subject { authorizer.authorization_code = code }

    context "when token_store is nil" do
      include_examples "generate authorization"
    end

    context "when token_store is not nil" do
      let(:token_store_file) { "spec/fixtures/tokens.yaml" }
      let(:authorizer) { described_class.new("MyClientId", "MyClientSecret", "MyScope", token_store_file: token_store_file) }

      include_examples "generate authorization"

      context "when code is valid" do
        let(:code) { "MyCode" }

        before { File.delete(token_store_file) if File.exist?(token_store_file) }

        it "saves credentials" do
          expect { subject }.to change { File.exist?(token_store_file) }.to(true)
        end

        after { File.delete(token_store_file) if File.exist?(token_store_file) }
      end
    end
  end
end
