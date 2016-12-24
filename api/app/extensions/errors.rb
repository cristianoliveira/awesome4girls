# frozen_string_literal: true

module Sinatra
  # Responsible for handling the common errors of the application adding
  # the corrects headers and status.
  #
  module ErrorsHandler
    def self.registered(app)
      app.set :show_exceptions, false

      # Handling resource not found
      app.error ActiveRecord::RecordNotFound do
        exception = env['sinatra.error']
        halt 404, json(errors: exception.message)
      end

      # Handling authentications
      app.error Sinatra::BasicAuth::AuthenticationError do
        exception = env['sinatra.error']
        halt 401, json(errors: exception.message)
      end
    end
  end
end
