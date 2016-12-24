# frozen_string_literal: true

# Responsible expose the user endpoints
#
class UsersController < ApiController
  before do
    content_type :json

    restricted_to!(User::ROLE_ADMIN)
  end

  # GET /users/1
  get '/:id' do
    user = User.find(params[:id])
    jsonapi(user, is_collection: false)
  end

  # GET /users
  get '/' do
    users = User.all
    jsonapi(users, is_collection: true)
  end

  # POST /users?name=bob&password=123&role=1
  post '/' do
    param :name, String, required: true
    param :password, String, required: true
    param :role, Integer, required: true

    user = User.new(params)

    if user.save
      json(message: 'User created.')
    else
      halt 400, jsonapi_errors(user.errors)
    end
  end

  # DELETE /users/1
  delete '/:id' do
    user = User.find(params[:id])

    if user.destroy
      jsonapi(user, is_collection: false)
    else
      halt 400, jsonapi_errors(user.errors)
    end
  end
end
