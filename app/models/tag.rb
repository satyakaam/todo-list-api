class Tag < ApplicationRecord
  has_and_belongs_to_many :tasks

  validates :title, presence: true, uniqueness: { case_sensitive: false }

  before_save :snake_case_title

  private

  def snake_case_title
    self.title = self.title.parameterize.underscore
  end
end
