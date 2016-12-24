# frozen_string_literal: true
#
# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  password   :string
#  role       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :admin, class: User do
    name 'admin'
    password 'admin'
    role 1
  end
  factory :user, class: User do
    name 'bob'
    password '123'
    role 2
  end
  factory :guest, class: User do
    name 'guest'
    password 'guest'
    role 3
  end
end
