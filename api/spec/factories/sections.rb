# frozen_string_literal: true
#
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

FactoryGirl.define do
  factory :section, class: Section do
    title 'some title'
    description 'some awesome description'
  end
end
