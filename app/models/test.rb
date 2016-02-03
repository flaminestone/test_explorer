class Test < ActiveRecord::Base
  validates :name, presence: {message: 'Название теста не может быть пустым'}
  belongs_to :section
  has_many :questions
end
