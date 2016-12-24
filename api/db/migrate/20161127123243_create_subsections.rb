class CreateSubsections < ActiveRecord::Migration[5.0]
  def change
    create_table :subsections do |t|
      t.string :title
      t.string :description
      t.references :section, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
