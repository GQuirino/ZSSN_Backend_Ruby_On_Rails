class CreateSurvivors < ActiveRecord::Migration[5.2]
  def change
    create_table :survivors do |t|
      t.string :name
      t.string :gender
      t.integer :age
      t.integer :flag_as_infected
      t.integer :points
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
  end
end
