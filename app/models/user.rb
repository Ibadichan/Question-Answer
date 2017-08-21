# frozen_string_literal: true

class User < ApplicationRecord
  TEMP_EMAIL_REGEX = /\Achange@me/

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes
  has_many :authorizations, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook twitter]

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info.email
    user = User.where(email: email).first

    unless user
      user = User.new(email: email ? email : "change@me-#{auth.uid}-#{auth.provider}.com",
                      name: auth.info.name, password: Devise.friendly_token[0, 20])

      user.skip_confirmation!
      user.save!
    end

    user.authorizations.create!(provider: auth.provider, uid: auth.uid.to_s) if user
    user
  end

  def email_verified?
    email !~ TEMP_EMAIL_REGEX
  end

  def author_of?(object)
    id == object.user_id
  end

  def cannot_vote_for?(votable)
    votable.votes.where(user_id: id).exists?
  end
end
