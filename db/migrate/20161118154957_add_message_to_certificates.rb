class AddMessageToCertificates < ActiveRecord::Migration[5.0]
  def change
    add_column :certificates, :message, :string
  end
end
