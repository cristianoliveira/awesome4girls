# frozen_string_literal: true
# == Schema Information
#
# Table name: sections
#
#  id          :integer          not null, primary key
#  title       :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# A Section is the highest division
#
# Ex:
#   Meetup <-- Secion
#     Ruby <-- Subsection
#       RailsGirls <-- Project
#
class Section < ActiveRecord::Base
  has_many :subsections

  validates :title, presence: true
end
