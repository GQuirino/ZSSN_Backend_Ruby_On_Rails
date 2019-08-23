class AddNotNullToInventories < ActiveRecord::Migration[5.2]
  def up
    change_table :inventories do |t|
      t.change :resource_type, :string, null: false
      t.change :resource_amount, :integer, null: false, default: 0
      t.index [:resource_type]
    end
  end

  def down
    remove_index :inventories, column: :resource_type

    change_table :inventories do |t|
      t.change :resource_type, :string, null: true, index: false
      t.change :resource_amount, :integer, null: true
    end
  end
end
