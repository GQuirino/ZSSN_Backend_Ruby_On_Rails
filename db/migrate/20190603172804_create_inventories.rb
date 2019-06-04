class CreateInventories < ActiveRecord::Migration[5.2]
  def change
    create_table :inventories do |t|
      t.references :survivor, foreing_key: true
      t.string :resource_type
      t.integer :resource_amount

      t.timestamps
    end
  end
end
