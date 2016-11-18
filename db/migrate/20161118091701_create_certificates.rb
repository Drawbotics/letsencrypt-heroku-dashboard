class CreateCertificates < ActiveRecord::Migration[5.0]
  def change
    create_table :certificates do |t|
      t.string :identifier
      t.string :domain
      t.string :subdomains
      t.string :app_name
      t.integer :debug
      t.string :status
    end
  end
end
