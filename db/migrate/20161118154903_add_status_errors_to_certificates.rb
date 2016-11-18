class AddStatusErrorsToCertificates < ActiveRecord::Migration[5.0]
  def change
    add_column :certificates, :status_errors, :string
  end
end
