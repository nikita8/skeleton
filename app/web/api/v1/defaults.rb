module API
  module V1
    # Default methods used in API::V1
    module Defaults
      extend ActiveSupport::Concern
      # common Grape settings
      included do
        prefix 'api'
        version 'v1'
        format :json
        # global handler for simple not found case
        rescue_from ActiveRecord::RecordNotFound do |e|
          notify_error(e)
          error!({ message: e.message }, 404)
        end

        # global exception handler, used for grape validation error
        rescue_from Grape::Exceptions::ValidationErrors do |e|
          error_response(message: e.full_messages, status: 422)
        end

        rescue_from Grape::Exceptions::InvalidMessageBody do
          error_response(message: 'Problem parsing the body', status: 400)
        end

        # global exception handler, used for error notifications
        rescue_from :all do |e|
          notify_error(e)
          error_response(message: 'Internal server error', status: 500)
        end
      end
    end
  end
end
