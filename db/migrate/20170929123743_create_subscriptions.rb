class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.string :type
      t.integer :length
      t.references :magazine, foreign_key: true
      t.references :reader, foreign_key: true

      t.timestamps
    end
  end
end
