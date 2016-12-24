class AddUniqueIndexToProjects < ActiveRecord::Migration[5.0]
  def change
    add_index(:projects, [:title, :subsection_id], unique: true)
  end
end
