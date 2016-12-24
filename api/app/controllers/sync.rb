# frozen_string_literal: true
require_relative 'base'

# Responsible to manage syncronizer calls
#
# It will be used for third parts applications to trigger syncronization.
#
class SyncController < ApiController
  post '/' do
    restricted_to!(User::ROLE_ADMIN)

    json(worker: SincronizerWorker.perform_async)
  end
end
