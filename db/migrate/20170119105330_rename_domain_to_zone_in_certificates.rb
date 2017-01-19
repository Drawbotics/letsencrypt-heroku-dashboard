class RenameDomainToZoneInCertificates < ActiveRecord::Migration[5.0]
  def change
    rename_column :certificates, :domain, :zone
    rename_column :certificates, :subdomains, :domains
  end
end
