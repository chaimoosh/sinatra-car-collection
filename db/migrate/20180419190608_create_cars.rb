class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
     t.string :year
     t.string :make
     t.string :model
     t.text :description
     t.integer :user_id
   end
  end
end
