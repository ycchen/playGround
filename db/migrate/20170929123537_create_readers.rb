class CreateReaders < ActiveRecord::Migration[5.1]
  def change
    create_table :readers do |t|
      t.string :name

      t.timestamps
    end
  end
end
