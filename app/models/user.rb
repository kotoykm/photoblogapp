class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :publications, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy #Definido por mi para el experimiento, debe tener una pura imagen. Especificar tambien en el formulario

  enum :role, [:user, :admin]

  after_create :attach_default_avatar
  before_destroy :purge_avatar

  private

  def attach_default_avatar
    unless avatar.attached?
      avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default-avatar.jpg')), filename: 'default-avatar.jpg', content_type: 'image/jpg')
    end
  end

  def purge_avatar
    avatar.purge if avatar.attached?
  end
end
