# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  full_name       :string(100)      not null
#  email           :string(100)      not null
#  phone           :integer
#  role            :integer          default("0"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

class User < ApplicationRecord
  has_secure_password
  has_many :artworks
  has_many :talks
  has_many :messages
  has_many :votes, as: :votable, dependent: :destroy
  has_many :owner_votes, class_name: 'Vote'

  enum role: [:client, :artist]

  validates :full_name, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, uniqueness: true
  validates :phone, numericality: { only_integer: true }, if: :phone?
  validates :role, inclusion: { in: User.roles.keys }

  def voted?(votable)
    self.owner_votes.find_by_votable_type_and_votable_id(votable.class.name, votable.id).present?
  end
end
