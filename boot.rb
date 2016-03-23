require 'rubygems'
require 'bundler'
require 'digest/sha1'

module App
  def self.root
    @root_path ||= FileUtils.pwd
  end
end

require File.expand_path("#{App.root}/config/environment.rb", __FILE__)

Grape::ActiveRecord.configure_from_file! "config/database.yml"
ActiveRecord::Base.logger = AppLogger.logger