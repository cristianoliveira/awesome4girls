# frozen_string_literal: true
# == Schema Information
#
# Table name: subsections
#
#  id          :integer          not null, primary key
#  title       :string
#  description :string
#  section_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# A Subsection is a lowest section
#
# Ex:
#   Meetup <-- Secion
#     Ruby <-- Subsection
#       RailsGirls <-- Project
#
class Subsection < ActiveRecord::Base
  belongs_to :section
  has_many :projects

  validates :title, presence: true
end
