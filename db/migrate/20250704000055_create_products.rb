class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.string :promotion_type
      t.decimal :promotion_value

      t.timestamps
    end
  end
end
