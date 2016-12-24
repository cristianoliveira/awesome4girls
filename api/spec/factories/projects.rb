# frozen_string_literal: true
#
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

FactoryGirl.define do
  factory :project, class: Project do
    title 'some title'
    link 'http://somelink'
    description 'some awesome description'

    subsection
  end
end
