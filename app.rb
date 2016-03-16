# encoding: utf-8
require File.expand_path('../boot', __FILE__)
Dir[File.join(File.dirname(__FILE__), 'middlewares', '*.rb')].each do |f|
  require(f)
end
I18n.enforce_available_locales = false

# Application Module
module ApplicationModule
  #  API class to mount all the Base API endpints
  class App < Grape::API
    helpers do
      def authenticate
        # user_token = request.env['HTTP_X_API_TOKEN'] || ''
        # error!('Unauthorized. Invalid API token.', 401)
      end
    end

    before do
      authenticate
    end

    mount API::Base
  end
end
