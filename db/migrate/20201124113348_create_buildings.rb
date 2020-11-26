class CreateBuildings < ActiveRecord::Migration[6.0]
  def change
    create_table :buildings do |t|
      t.string :reference
      t.string :address
      t.string :zip_code
      t.string :city
      t.string :country
      t.string :manager_name
      t.text   :versions, default: [].to_yaml

      t.timestamps
    end
  end
end
