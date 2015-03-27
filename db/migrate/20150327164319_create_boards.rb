class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.text :name
      t.string :description
      t.references :parent, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
