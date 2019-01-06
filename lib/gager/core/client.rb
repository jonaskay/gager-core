require 'google/apis/analyticsreporting_v4'

module Gager
  module Core
    class Client
      API = Google::Apis::AnalyticsreportingV4

      def initialize(authorization)
        @service = API::AnalyticsReportingService.new
        @service.authorization = authorization
      end

      def get_reports(requests_attributes)
        report_requests = requests_attributes.map { |request| generate_report_request(request) }
        request = API::GetReportsRequest.new(report_requests: report_requests)
        @service.batch_get_reports(request)
      end

      private

      def generate_report_request(attrs)
        API::ReportRequest.new(
          view_id: attrs[:view_id],
          date_ranges: attrs[:date_ranges].map { |a| API::DateRange.new(start_date: a[0], end_date: a[1]) },
          dimensions: attrs[:dimensions].map { |s| API::Dimension.new(name: s) },
          metrics: attrs[:metrics].map { |s| API::Metric.new(expression: s) },
          filters_expression: attrs[:filters_expression]
        )
      end
    end
  end
end
