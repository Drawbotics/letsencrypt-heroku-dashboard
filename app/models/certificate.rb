class Certificate < ApplicationRecord

  validates :domain, presence: true
  validates :app_name, presence: true

  belongs_to :user

end
