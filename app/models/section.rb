class Section < ActiveRecord::Base
  validates :name, presence: {message: 'Название секции не может быть пустым'}
  has_many :tests
end
