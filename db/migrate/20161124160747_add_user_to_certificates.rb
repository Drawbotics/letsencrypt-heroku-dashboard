class AddUserToCertificates < ActiveRecord::Migration[5.0]
  def change
    add_reference :certificates, :user, foreign_key: true
  end
end
