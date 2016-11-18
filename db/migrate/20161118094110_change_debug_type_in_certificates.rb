class ChangeDebugTypeInCertificates < ActiveRecord::Migration[5.0]
  def change
    change_column :certificates, :debug, 'boolean USING CAST(debug AS boolean)'
  end
end
