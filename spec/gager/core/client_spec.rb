RSpec.describe Gager::Core::Client do
  it "initializes" do
    expect(described_class.new({})).to be_instance_of(Gager::Core::Client)
  end
end
