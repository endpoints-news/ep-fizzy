class AddAccessedAtToAccesses < ActiveRecord::Migration[8.1]
  def change
    add_column :accesses, :accessed_at, :datetime
    add_index :accesses, :accessed_at, order: { accessed_at: :desc }
  end
end
