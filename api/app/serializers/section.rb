# frozen_string_literal: true
require_relative 'base'

# Serializer for section.
#
class SectionSerializer < BaseSerializer
  attributes :title, :description

  has_many :subsections
end
