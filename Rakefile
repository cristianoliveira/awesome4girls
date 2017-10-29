require_relative 'lib/awesome_list'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :gen do
  desc "Generate an html version of this list"
  task :html do
    readme = File.open("README.md", "rb").read
    p AwesomeList.parse(readme).raw_html
  end
end
