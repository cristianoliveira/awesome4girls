# frozen_string_literal: true
#
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

FactoryGirl.define do
  factory :subsection, class: Subsection do
    title 'some title'
    description 'some awesome description'
    section
  end
end
