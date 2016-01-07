class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.string :name
      t.boolean :answer
      t.integer :question_id

      t.timestamps null: false
    end
  end
end
