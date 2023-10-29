# frozen_string_literal: true

class CreateReadings < ActiveRecord::Migration[7.1]
  def change
    create_table :readings do |t|
      t.string :zipcode
      t.float :temp
      t.float :temp_min
      t.float :temp_max
      t.string :icon
      t.string :main
      t.string :description
      t.float :wind
      t.integer :wind_direction

      t.timestamps
    end
    add_index :readings, :zipcode
  end
end
