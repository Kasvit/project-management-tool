# == Schema Information
#
# Table name: projects
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Project < ApplicationRecord
  has_many :tasks
  has_many :comments, as: :commentable
  belongs_to :user

  validates :name, length: { maximum: 250 }, presence: true
  paginates_per  5
end
