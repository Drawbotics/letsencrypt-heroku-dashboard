class Certificate < ApplicationRecord

  validates :zone, presence: true
  validates :app_name, presence: true

  belongs_to :user

end
