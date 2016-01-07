class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :name
      t.integer :test_id

      t.timestamps null: false
    end
  end
end
