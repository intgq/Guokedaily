class User < ApplicationRecord
    has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  attr_accessor :remember_token, :activation_token
  before_create :generate_activation_token
  before_save :downcase_email

  validates :password, presence: true, allow_nil: true

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :email, presence: true, format: {
    with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "Email
          Format Invalid"
  }, uniqueness: { case_sensitive: false }

  # 计算用户的访问令牌并存至数据库
  def remember
    self.remember_token = User.new_token
    self.update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  # 通用认证记忆令牌和激活令牌
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # 清空用户访问令牌
  def forget
    self.update_attribute(:remember_digest, nil)
  end

  # 获取用户首页微博动态流
  def feed
    # 请在下面完成要求的功能
    #********* Begin *********#
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
    #********* End *********#
  end

  # 关注另一个用户
  def follow(other_user)
    self.active_relationships.create(followed_id: other_user.id)
  end

  # 取消关注另一个用户
  def unfollow(other_user)
    self.active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 判断当前用户是否关注了指定用户
  def following?(other_user)
    self.following.include?(other_user)
  end

  private

    def generate_activation_token
      self.activation_token = User.new_token
      self.activation_digest = User.digest(self.activation_token)
    end

    def downcase_email
      self.email = self.email.downcase
    end

  class << self
    # 返回提供参数 string 的散列摘要值
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # 返回一个22位长的随机字符串
    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
