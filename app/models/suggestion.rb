class Suggestion < ApplicationRecord
  belongs_to :user
  belongs_to :list
  validates :content, length: { minimum: 10 }
end
