require 'google/apis/analyticsreporting_v4'

module Gager
  module Core
    class Client
      def initialize(authorization)
        @service = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
        @service.authorization = authorization
      end
    end
  end
end
