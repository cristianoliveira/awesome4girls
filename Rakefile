require_relative 'lib/awesome_list'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :setup do
  p "Installing misspell for common misspelling checks"
  p `curl -L https://git.io/misspell | bash`
end

namespace :gen do
  desc "Generate an html version of this list"
  task :html do
    readme = File.open("README.md", "rb").read
    p AwesomeList.parse(readme).raw_html
  end
end
