class CreateAsteroids < ActiveRecord::Migration[7.2]
  def change
    create_table :asteroids do |t|
      t.string :name
      t.date :close_approach_date
      t.boolean :is_potentially_hazardous
      t.float :magnitude
      t.float :estimated_diameter
      t.float :relative_velocity
      t.string :nasa_jpl_url

      t.timestamps
    end
  end
end
