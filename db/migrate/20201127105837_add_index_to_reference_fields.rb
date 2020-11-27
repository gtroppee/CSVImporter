class AddIndexToReferenceFields < ActiveRecord::Migration[6.0]
  def change
    add_index :buildings, :reference
    add_index :people, :reference
  end
end
