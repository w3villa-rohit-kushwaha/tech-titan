class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,omniauth_providers: [:google_oauth2]

  # has_many :messages
  has_many :sent_chats, class_name: "Chat", foreign_key: "sender_id"
  has_many :received_chats, class_name: "Chat", foreign_key: "receiver_id"
  
  has_many :bookings
  has_many :hotels
  has_many :reviews
  has_many :user_roles
  has_many :roles, through: :user_roles


  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.fullname = auth.info.name
      user.avatar_url = auth.info.image
    end
  end
end
