# frozen_string_literal: true
require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/json'
require 'sinatra/param'
require 'sinatra/cross_origin'

require 'digest/md5'
require 'json'
require 'jsonapi-serializers'
require 'uri'
require 'net/http'

require 'sidekiq/web'
require 'kramdown'

configure do
  enable :cross_origin
end

require_relative './config/sidekiq.rb'

Dir.glob(File.join(__dir__, 'app/workers/*.rb')).each { |file| require file }
Dir.glob(File.join(__dir__, 'app/components/*.rb')).each { |file| require file }
Dir.glob(File.join(__dir__, 'app/extensions/*.rb')).each { |file| require file }
Dir.glob(File.join(__dir__, 'app/serializers/*.rb')).each { |file| require file }
Dir.glob(File.join(__dir__, 'app/models/*.rb')).each { |file| require file }
Dir.glob(File.join(__dir__, 'app/controllers/*.rb')).each { |file| require file }

# The app routes.
#
class App
  VERSION = '0.0.1'

  def self.routes
    {
      '/' => MainController,
      '/users' => UsersController,
      '/sections' => SectionsController,
      '/subsections' => SubsectionsController,
      '/projects' => ProjectsController,
      '/sync' => SyncController,
      '/workers' => WorkersController
    }
  end
end
