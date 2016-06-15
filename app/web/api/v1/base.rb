Dir[File.join(File.dirname(__FILE__), '*.rb')].each { |f| require f }

module API
  module V1
    class Base < Grape::API
      include API::V1::Defaults
      # mount base API
      # mount API::V1::Home
    end
  end
end
