class CreateSections < ActiveRecord::Migration[5.0]
  def change
    create_table :sections do |t|
      t.string :title
      t.string :description

      t.timestamps null: false
    end
  end
end
