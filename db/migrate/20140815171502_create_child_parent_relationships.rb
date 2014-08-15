class CreateChildParentRelationships < ActiveRecord::Migration
  def change
    create_table :child_parent_relationships do |t|
      t.column :person_id, :integer
      t.column :parent_id, :integer
      t.column :child_id, :integer
    end
    remove_column :people, :child_id, :integer
    remove_column :people, :parent_id, :integer
  end
end
