class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { minimum: 2, maximum: 20}
  validates :introduction, length: { maximum: 50 }

  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id
  has_many :followings, through: :active_relationships, source: :follower
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :followers, through: :passive_relationships, source: :following
  attachment :profile_image

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  def followed_by?(user)
    passive_relationships.where(following_id: user.id).exists?
  end

  def User.search(search, model, how)
    if model == "user"
      if how == "partical"
        User.where("name LIKE ?", "%#{search}%")
      elsif how == "forward"
        User.where("name LIKE ?", "#{search}%")
      elsif how == "backward"
        User.where("name LIKE?", "%#{search}")
      elsif how == "match"
        User.where("name LIKE?", "#{search}")
      end
    end
  end
# 住所自動入力関連
  include JpPrefecture
  jp_prefecture :prefecture_code

  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

# Google Map API関連
  class User
    attr_accessor :city_address, :street_address

    def address
      Address.new(city_address, town_address, building_address)
    end
  end

  class Address
    attr_reader :city, :street

    def initialize(city, street)
      @city, @street = city, stree
    end
  end

  geocoded_by :address
  after_validation :geocode, if: :address_changed?
end
