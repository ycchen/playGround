class AddManagerToEmployee < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :manager_id, :integer
  end
end
