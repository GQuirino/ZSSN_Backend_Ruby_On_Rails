class AddNotNullToSurvivors < ActiveRecord::Migration[5.2]
  def up
    change_table :survivors do |t|
      t.change :name, :string, null: false
      t.change :gender, :string, null: false
      t.change :age, :integer, null: false
      t.change :flag_as_infected, :integer, null: false, default: 0
      t.change :points, :integer, null: false
      t.change :latitude, :string, null: false
      t.change :longitude, :string, null: false
    end
  end

  def down
    change_table :survivors do |t|
      t.change :name, :string, null: true
      t.change :gender, :string, null: true
      t.change :age, :integer, null: true
      t.change :flag_as_infected, :integer, null: true
      t.change :points, :integer, null: true
      t.change :latitude, :string, null: true
      t.change :longitude, :string, null: true
    end
  end
end
