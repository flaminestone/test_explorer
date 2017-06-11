class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.string :name
      t.integer :variant
      t.integer :section_id
      t.boolean :come_back, :default => true
      t.timestamps null: false
    end
  end
end
