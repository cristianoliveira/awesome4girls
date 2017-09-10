# frozen_string_literal: true

require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :rubocop do
  RuboCop::RakeTask.new
end

task default: :test
task test: ['db:test:prepare', :spec]

namespace :db do
  task :load_config do
    require_relative 'app'
  end
end

task :sync do
  require_relative 'app'
  SincronizerWorker.new.perform
end
