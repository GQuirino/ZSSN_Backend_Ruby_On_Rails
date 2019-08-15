class AddNotNullToInventories < ActiveRecord::Migration[5.2]
  def up
    change_table :inventories do |t|
      t.change :resource_type, :string, null: false
      t.change :resource_amount, :integer, null: false, default: 0
    end
  end

  def down
    change_table :inventories do |t|
      t.change :resource_type, :string, null: true
      t.change :resource_amount, :integer, null: true
    end
  end
end
