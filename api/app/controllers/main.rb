# frozen_string_literal: true

# Responsible to provide the right context for controllers
#
class MainController < ApiController
  get '/' do
    json(message: 'welcome to the awesome4girls api. See the docs ' \
          'for details: https://github.com/cristianoliveira/awesome4girls-api')
  end

  get '/version' do
    json(version: App::VERSION)
  end

  not_found do
    json(message: 'You probabily are lost.'\
    'see the docs: https://github.com/cristianoliveira/awesome4girls-api')
  end
end
