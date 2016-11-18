class Certificate < ApplicationRecord

  validates :domain, presence: true
  validates :app_name, presence: true

end
