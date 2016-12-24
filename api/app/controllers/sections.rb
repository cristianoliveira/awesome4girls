# frozen_string_literal: true
require_relative 'base'

# Responsible expose subsection endpoints
#
class SectionsController < ApiController
  # GET /sections/1
  get '/:id' do
    section = Section.find(params[:id])
    jsonapi(section, is_collection: false)
  end

  # GET /sections/1/subsections
  get '/:id/subsections' do
    section = Section.find(params[:id])
    jsonapi(section.subsections, is_collection: true)
  end

  # GET /sections
  get '/' do
    jsonapi(Section.all, is_collection: true)
  end

  # POST /sections?title=meetup&description=somedescription
  post '/' do
    restricted_to!(User::ROLE_USER)

    param :title, String, required: true
    param :description, String

    section = Section.new(params)

    if section.save
      jsonapi(section, is_collection: false)
    else
      halt 400, json_errors(section.errors)
    end
  end

  # PUT /sections/:id?title=meetup&description=somedescription
  put '/:id' do
    restricted_to!(User::ROLE_USER)
    param :title, String, required: true
    param :description, String

    section = Section.find(params[:id])
    section.update_attributes(title: params[:title],
                              description: params[:description])

    if section.save
      jsonapi(section, is_collection: false)
    else
      halt 400, json_errors(section.errors)
    end
  end

  # DELETE /sections/1
  delete '/:id' do
    restricted_to!(User::ROLE_USER)
    section = Section.find(params[:id])

    if section.destroy
      json(message: 'section deleted.')
    else
      halt 400, json(errors: section.errors.full_messages)
    end
  end
end
