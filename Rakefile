require_relative 'lib/parser'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :all => :spec

namespace :gen do
  desc "Generate an html version of this list"
  task :html do
    readme = File.open("README.md", "rb").read
    p AwesomeListRender.parse(readme).raw_html
  end
end
