# frozen_string_literal: true
require_relative 'base'

# Serializer for user.
#
class UserSerializer < BaseSerializer
  attributes :name, :role
end
