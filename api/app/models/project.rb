# frozen_string_literal: true
# == Schema Information
#
# Table name: projects
#
#  id            :integer          not null, primary key
#  title         :string
#  description   :string
#  language      :string
#  subsection_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  author_id     :integer
#

# The project has the details of the event/group/project.
#
# Ex:
#   Meetup <-- Secion
#     Ruby <-- Subsection
#       RailsGirls <-- Project
#         description: An event that brings women to the tech.
#
class Project < ActiveRecord::Base
  belongs_to :subsection
  belongs_to :author, class_name: 'User'

  validates :title, presence: true
  validates :link, presence: true
  validates :description, presence: true
  validates :language, length: {
    maximum: 2,
    allow_nil: true,
    message: 'Languages must be ISO639-1 code standard. Ex: en, pt'
  }

  # It validates who are destroying the record ensuring
  # that only allowed person can delete it.
  #
  # == Parameters:
  # user:: The user that is trying delete the record
  #
  # == Returns:
  # A boolean that responds if was possible delete it.
  #
  def destroy_by(user)
    unless author_id == user.id || user.is_a?(User::ROLE_ADMIN)
      errors.add(:not_allowed, 'Cannot delete projects from other author')
      return false
    end

    destroy
  end
end
