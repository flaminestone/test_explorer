class Question < ActiveRecord::Base
  validates :name, presence: {message: 'Название вопроса не может быть пустым'}
  belongs_to :test
  has_many :variants
end
