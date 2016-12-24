class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.string :description
      t.string :language
      t.references :subsection, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
