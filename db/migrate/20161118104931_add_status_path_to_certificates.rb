class AddStatusPathToCertificates < ActiveRecord::Migration[5.0]
  def change
    add_column :certificates, :status_path, :string
  end
end
