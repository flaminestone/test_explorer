class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.string :group
      t.string :section_result_name
      t.string :test_result_name
      t.string :result
      t.timestamps null: false
    end
  end
end
