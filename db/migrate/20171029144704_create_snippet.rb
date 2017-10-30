class CreateSnippet < ActiveRecord::Migration[5.1]
  def change
    create_table :snippets do |t|
      t.string :name
      t.string :language
      t.text :plain_code
      t.text :highlighted_code
    end
  end
end
