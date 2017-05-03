# frozen_string_literal: true

# This the base controller for the api.
# If the route responds Json it should inherit from it.
#
class ApiController < Sinatra::Base
  register Sinatra::ErrorsHandler
  register Sinatra::CrossOrigin
  helpers Sinatra::BasicAuth
  helpers Sinatra::JsonApi
  helpers Sinatra::Param

  before do
    cross_origin
    content_type :json
  end

  def restricted_to!(role)
    restricted! do |name, pass|
      @user = User.authenticate(name, pass, role)
    end
  end

  def current_user
    name, _ = credentials(request)
    User.find_by_name(name)
  end
end
