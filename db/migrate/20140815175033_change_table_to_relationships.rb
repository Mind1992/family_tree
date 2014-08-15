class ChangeTableToRelationships < ActiveRecord::Migration
  def change
    rename_table :child_parent_relationships, :relationships
  end
end
