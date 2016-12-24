class AddAuthorToProjects < ActiveRecord::Migration[5.0]
  def change
    add_reference :projects, :author, references: :users, index: true
  end
end
