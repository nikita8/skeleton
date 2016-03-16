require File.join(File.dirname(__FILE__), 'v1', 'base')
module API
  # Base API class to mount multiple versions base classes
  class Base < Grape::API
    mount API::V1::Base
  end
end
