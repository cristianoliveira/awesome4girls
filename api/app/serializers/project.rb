# frozen_string_literal: true
require_relative 'base'

# Serializer for section.
#
class ProjectSerializer < BaseSerializer
  attributes :link, :title, :description, :language, :author
end
