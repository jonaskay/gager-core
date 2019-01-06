RSpec.describe Gager::Core::Client do
  let(:client) { described_class.new({}) }

  describe "#get_reports" do
    let(:report_requests) {
      [
        {
          view_id: "MyViewId",
          date_ranges: [["2015-06-15", "2015-06-30"]],
          metrics: ["ga:sessions"],
          dimensions: ["ga:browser"],
          filters_expression: nil
        }
      ]
    }

    before {
      stub_request(:post, "https://analyticsreporting.googleapis.com/v4/reports:batchGet")
        .with(
          body: {
            "reportRequests" => [
              {
                "dateRanges" => [{ "endDate" => "2015-06-30", "startDate" => "2015-06-15" }],
                "dimensions" => [{"name" => "ga:browser"}],
                "filtersExpression" => nil,
                "metrics" => [{ "expression" => "ga:sessions" }],
                "viewId" => "MyViewId"
              }
            ]
          }.to_json
        )
        .to_return(
          status: 200,
          body: {
            "reports" => [
              {
                "columnHeader" => {
                  "dimensions" => ["ga:browser"],
                  "metricHeader" => {
                    "metricHeaderEntries" => [{ "name" => "ga:sessions", "type" => "INTEGER" }]
                  }
                },
                "data" => {
                  "rows" => [
                    {
                      "dimensions" => ["Firefox"],
                      "metrics" => [{ "values" => ["2161"] }]
                    },
                    {
                      "dimensions" => ["Internet Explorer"],
                      "metrics" => [{ "values" => ["1705"] }]
                    }
                  ],
                  "totals" => [
                    {
                      "values" => ["3866"]
                    }
                  ]
                }
              }
            ]
          }.to_json,
          headers: {
            "Content-Type" => "application/json"
          }
        )
    }

    subject { client.get_reports(report_requests) }

    it { is_expected.to be_instance_of(Google::Apis::AnalyticsreportingV4::GetReportsResponse) }
  end
end
