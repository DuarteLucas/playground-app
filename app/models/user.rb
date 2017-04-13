class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, omniauth_providers: [:facebook]


  after_create :send_welcome_email

  has_many :lists, foreign_key: :user_id
  has_many :tags, foreign_key: :user_id #feature to be added later
  has_many :favourites, foreign_key: :user_id
  has_many :tagged_movies, through: :tags, source: :movie #feature to be added later
  has_many :favourite_movies, through: :favourites, source: :movie #feature to be added later
  has_many :suggestions #feature to be added later
  # User to user following relationships (followships)
  has_many :follower_followships, :class_name => 'Followship', :foreign_key => :follower_id # connects users to foreign keys and their role
  has_many :followee_followships, :class_name => 'Followship', :foreign_key => :followee_id
  has_many :followers, :through => :followee_followships # links their role as follower to whoever is their followee (following them)
  has_many :followees, :through => :follower_followships

  def self.find_for_facebook_oauth(auth)
    user_params = auth.slice(:provider, :uid)
    user_params.merge! auth.info.slice(:email, :first_name, :last_name)
    user_params[:facebook_picture_url] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at)
    user_params = user_params.to_h

    user = User.where(provider: auth.provider, uid: auth.uid).first
    user ||= User.where(email: auth.info.email).first # User did a regular sign up in the past.
    if user
      user.update(user_params)
    else
      user = User.new(user_params)
      user.password = Devise.friendly_token[0,20]  # Fake password for validation
      user.save
      UserMailer.welcome(user).deliver_now
    end

    return user
  end

  def followees
    super.uniq
  end

  def followers
    super.uniq
  end

  def profile_picture_url
    facebook_picture_url || 'http://i.imgur.com/65Rkme6.png'
  end

  private

  def send_welcome_email
    UserMailer.welcome(self).deliver_now
  end

end
